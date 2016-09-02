
//
//  ScanManager.m
//  SZQRCodeViewController
//
//  Created by MenThu on 16/9/2.
//  Copyright © 2016年 StephenZhuang. All rights reserved.
//

#import "ScanManager.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanManager ()<AVCaptureMetadataOutputObjectsDelegate>

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
        [self setupCamera];
    }
    return self;
}

- (void)setupCamera
{
    
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

//结束扫描
- (void)endScan
{
    [self.session stopRunning];
    self.device = nil;
    self.input = nil;
    self.output = nil;
    self.preview = nil;
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
        self.endBlock(stringValue);
    }
}

@end
