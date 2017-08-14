//
//  UIImageView+Work.m
//  artapp
//
//  Created by MenThu on 2017/4/28.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "UIImageView+Work.h"

@implementation UIImageView (Work)

- (void)clip:(UIBezierPath *)clipPath{
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    //开始绘制图片
    UIGraphicsBeginImageContext(self.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    CGPathRef path = clipPath.CGPath;
    CGContextAddPath(gc, path);
    //坐标系转换
    //因为CGContextDrawImage会使用Quartz内的以左下角为(0,0)的坐标系
    CGContextTranslateCTM(gc, 0, height);
    CGContextScaleCTM(gc, 1, -1);
    
    
    CGContextClosePath(gc);
    
    CGContextAddRect(gc, CGContextGetClipBoundingBox(gc));
    CGContextEOClip(gc);
    
    //绘制图片
    CGContextDrawImage(gc, CGRectMake(0, 0, width, height), [self.image CGImage]);
    
    //结束绘画
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    //对image重新赋值
    self.image = clipImage;
    UIGraphicsEndImageContext();
}

@end
