
//
//  ScanManager.m
//  SZQRCodeViewController
//
//  Created by MenThu on 16/9/2.
//  Copyright © 2016年 StephenZhuang. All rights reserved.
//

#import "ScanManager.h"
#import "CameraManager.h"
#import "KMQRCode.h"
#import <AVFoundation/AVFoundation.h>
#import "MyLog.h"

@interface ScanManager ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate> 

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, copy) ScanRezult endBlock;

@end

@implementation ScanManager

kSingletonM


- (instancetype)init
{
    if (self = [super init]) {
        self.device = nil;
        self.input = nil;
        self.output = nil;
        self.session = nil;
        self.preview = nil;
    }
    return self;
}

- (void)startScanInAlbum:(ScanRezult)scanBlock
{
    self.endBlock = scanBlock;
    [[CameraManager shareInstance] changeDelegate:self];
    [[CameraManager shareInstance] takePhotoUseType:FromAlbum With:nil];
}

#pragma mark- ImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //2.初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    [picker dismissViewControllerAnimated:YES completion:^{
        //监测到的结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >= 1) {
            /**结果对象 */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            if (scannedResult && self.endBlock) {
                self.endBlock(scannedResult);
                self.endBlock = nil;
            }
        }
        else{
            NSLog(@"该图片没有包含一个二维码！");
        }
    }];
}


//开始扫描
- (void)startScanWithView:(UIView *)scanView Rezult:(ScanRezult)scanBlock
{
    //检查是否持有相册权限
    if ([self checkRightForCamer]) {
        
        self.endBlock = scanBlock;
        
        if (!self.device) {
            self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        }
        
        if (!self.input) {
            self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        }
        
        if (!self.output) {
            self.output = [[AVCaptureMetadataOutput alloc]init];
            [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        }
        
        if (!self.session) {
            self.session = [[AVCaptureSession alloc]init];
            [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        }
        
        if ([self.session canAddInput:self.input]) {
            [self.session addInput:self.input];
        }
        
        if ([self.session canAddOutput:self.output]) {
            [self.session addOutput:self.output];
            self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            // Preview
            _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            _preview.frame = scanView.bounds;
            [scanView.layer insertSublayer:self.preview atIndex:0];
            // Start
            [_session startRunning];
        });
    }
}

- (void)saveORCode:(UIImage *)ORImage Rezult:(ScanRezult)saveRezult
{
    self.endBlock = saveRezult;
    UIImageWriteToSavedPhotosAlbum(ORImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (self.endBlock) {
        NSMutableDictionary *save2AlbumRezult;
        if(!error){
            save2AlbumRezult = [NSMutableDictionary dictionaryWithDictionary:@{@"code":@(0)}];
        }else{
            MyLog(@"%@", contextInfo);
            save2AlbumRezult = [NSMutableDictionary dictionaryWithDictionary:@{@"code":@(1)}];
        }
        self.endBlock(save2AlbumRezult);
        self.endBlock = nil;
    }
}

//结束扫描
- (void)endScan
{
    [self.session stopRunning];
    self.device = nil;
    self.input = nil;
    self.output = nil;
    self.preview = nil;
}


- (UIImage *)createORImageWithInfo:(NSString *)ORString andSize:(CGSize)ORImageSize centerIcon:(UIImage *)centerImage
{
    NSString *source = ORString;
    
    //使用iOS 7后的CIFilter对象操作，生成二维码图片imgQRCode（会拉伸图片，比较模糊，效果不佳）
    CIImage *imgQRCode = [KMQRCode createQRCodeImage:source];
    
    //使用核心绘图框架CG（Core Graphics）对象操作，进一步针对大小生成二维码图片imgAdaptiveQRCode（图片大小适合，清晰，效果好）
    UIImage *imgAdaptiveQRCode = [KMQRCode resizeQRCodeImage:imgQRCode
                                                    withSize:ORImageSize.width];
    
    //默认产生的黑白色的二维码图片；我们可以让它产生其它颜色的二维码图片，例如：蓝白色的二维码图片
    imgAdaptiveQRCode = [KMQRCode specialColorImage:imgAdaptiveQRCode
                                            withRed:33.0
                                              green:114.0
                                               blue:237.0]; //0~255
    
    
    CGFloat centerImageWidh = ORImageSize.width/5.f;
    //使用核心绘图框架CG（Core Graphics）对象操作，创建带圆角效果的图片
    UIImage *imgIcon = [UIImage createRoundedRectImage:centerImage
                                              withSize:CGSizeMake(centerImageWidh, centerImageWidh)
                                            withRadius:10];
    
    
    //使用核心绘图框架CG（Core Graphics）对象操作，合并二维码图片和用于中间显示的图标图片
    imgAdaptiveQRCode = [KMQRCode addIconToQRCodeImage:imgAdaptiveQRCode
                                              withIcon:imgIcon
                                          withIconSize:imgIcon.size];
    return imgAdaptiveQRCode;
}

- (BOOL)checkRightForCamer
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        return NO;
    }else{
        return YES;
    }
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        [self endScan];
        if (self.endBlock) {
            self.endBlock(stringValue);
            self.endBlock = nil;
        }
    }
}

@end
