//
//  CameraManager.m
//  CGLearn
//
//  Created by MenThu on 16/7/18.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "CameraManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CameraManager ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImagePickerController *_imagePickerController;
}
@property (copy, nonatomic)CameraPhoto imageBlock;

@end

@implementation CameraManager

+ (instancetype)shareInstance
{
    static id selfPoint = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        selfPoint = [[self alloc] init];
    });
    return selfPoint;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initMyPickController];
    }
    return self;
}

- (void)initMyPickController
{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePickerController.allowsEditing = YES;
}

- (void)changeDelegate:(id)delegate
{
    _imagePickerController.delegate = delegate;
}

- (void)takePhotoUseType:(ManagerType)type With:(CameraPhoto)returnImage
{
    self.imageBlock = returnImage;
    switch (type) {
        case FromAlbum:
            //从相册中获取
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_imagePickerController animated:YES completion:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该设备不支持选取照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
           
        }
            break;
            
        case FromCamera:
            //拍摄照片
        {
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_imagePickerController animated:YES completion:nil];
            }else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该设备没有照相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma makr - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
            //如果是图片
            UIImage* image = info[UIImagePickerControllerEditedImage];
            if (self.imageBlock) {
                self.imageBlock(image);
            }
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
