//
//  UIImage+Work.h
//  JianShu
//
//  Created by MenThu on 16/7/27.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  拉伸一张图片
 */
+ (UIImage *)resizeImage:(NSString *)imgName;

/**
 *  通过UIColor创建一张图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color Size:(CGSize)imageSize;

/**
 *  将gif图片解析成UIImage的数组
 */
+ (void)analyzeGif2UIImage:(NSURL *)gifUrl returnData:(void(^)
                                                             (NSArray <UIImage *> *imageArray,
                                                              NSArray<NSNumber *> *timeArray,
                                                              NSArray <NSNumber *> *widths,
                                                              NSArray <NSNumber *> *heights,
                                                              CGFloat totalTime
                                                              ))returnBlock;

- (UIImage *)scaleImage:(CGSize)scaleSize;


+ (UIImage *)createRoundedRectImage:(UIImage *)image withSize:(CGSize)size withRadius:(NSInteger)radius;

@end
