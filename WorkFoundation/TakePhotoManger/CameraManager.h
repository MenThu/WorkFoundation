//
//  CameraManager.h
//  CGLearn
//
//  Created by MenThu on 16/7/18.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CameraPhoto)(id image);

@interface CameraManager : NSObject

+ (instancetype)shareInstance;
- (void)takePhoto:(CameraPhoto)returnImage;

@end
