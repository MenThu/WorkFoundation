//
//  UIImageView+Work.h
//  artapp
//
//  Created by MenThu on 2017/4/28.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Work)

/**
 *  裁剪图片
 *  clipPath    被裁剪的路径一定是相对UIImageView本身的,所以path应该是坐标转换后的值
 **/
- (void)clip:(UIBezierPath *)clipPath;

@end
