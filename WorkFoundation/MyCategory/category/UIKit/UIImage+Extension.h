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

/**
 *  Get blured image.
 *
 *  @return Blured image.
 */
- (UIImage *)blurImage;

/**
 *  Get the blured image masked by another image.
 *
 *  @param maskImage Image used for mask.
 *
 *  @return the Blured image.
 */
- (UIImage *)blurImageWithMask:(UIImage *)maskImage;

/**
 *  Get blured image and you can set the blur radius.
 *
 *  @param radius Blur radius.
 *
 *  @return Blured image.
 */
- (UIImage *)blurImageWithRadius:(CGFloat)radius;

/**
 *  Get blured image at specified frame.
 *
 *  @param frame The specified frame that you use to blur.
 *
 *  @return Blured image.
 */
- (UIImage *)blurImageAtFrame:(CGRect)frame;

#pragma mark - Grayscale Image

/**
 *  Get grayScale image.
 *
 *  @return GrayScaled image.
 */
- (UIImage *)grayScale;

#pragma mark - Some Useful Method

/**
 *  Scale image with fixed width.
 *
 *  @param width The fixed width you give.
 *
 *  @return Scaled image.
 */
- (UIImage *)scaleWithFixedWidth:(CGFloat)width;

/**
 *  Scale image with fixed height.
 *
 *  @param height The fixed height you give.
 *
 *  @return Scaled image.
 */
- (UIImage *)scaleWithFixedHeight:(CGFloat)height;

/**
 *  Get the image average color.
 *
 *  @return Average color from the image.
 */
- (UIColor *)averageColor;

/**
 *  Get cropped image at specified frame.
 *
 *  @param frame The specified frame that you use to crop.
 *
 *  @return Cropped image
 */
- (UIImage *)croppedImageAtFrame:(CGRect)frame;


@end
