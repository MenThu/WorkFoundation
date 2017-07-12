//
//  MTPhotoPreviewModel.h
//  artapp
//
//  Created by MenThu on 17/7/11.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTPhotoPreviewModel : NSObject

/**
 *  图片路径，全路径
 **/
@property (nonatomic, copy) NSString *imgUrl;

/**
 *  图片
 **/
@property (nonatomic, strong) UIImage *imgIcon;

/**
 *  当type为0时，使用imgUrl
 *  当type为1时，使用imgIcon
 **/
@property (nonatomic, assign) NSInteger type;

@end
