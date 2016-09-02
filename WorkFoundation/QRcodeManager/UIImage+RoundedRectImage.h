//
//  UIImage+RoundedRectImage.h
//  QRcode_GHdemo
//
//  Created by MenThu on 16/9/2.
//  Copyright © 2016年 Hope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundedRectImage)

+ (UIImage *)createRoundedRectImage:(UIImage *)image withSize:(CGSize)size withRadius:(NSInteger)radius;

@end
