//
//  UIImage+Work.h
//  JianShu
//
//  Created by MenThu on 16/7/27.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Work)

/**
 *  拉伸一张图片
 */
+ (UIImage *)resizeImage:(NSString *)imgName;

/**
 *  通过UIColor创建一张图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color Size:(CGSize)imageSize;

@end
