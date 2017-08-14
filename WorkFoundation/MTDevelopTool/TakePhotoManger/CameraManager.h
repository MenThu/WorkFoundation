//
//  CameraManager.h
//  CGLearn
//
//  Created by MenThu on 16/7/18.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef void(^CameraPhoto)(UIImage *image);

typedef enum : NSUInteger {
    ManagerTypeCamera,
    ManagerTypeAlbum
} ManagerType;


@interface CameraManager : NSObject

kSingletonH;

//拍摄照片或者从相册中读取照片
- (void)takePhotoUseType:(ManagerType)type With:(CameraPhoto)returnImage;

//设置代理【获取二维码的时候，对照片的筛选】
- (void)changeDelegate:(id)delegate;


@end
