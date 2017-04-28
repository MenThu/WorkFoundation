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
 裁剪图片
 **/
- (void)clip:(UIBezierPath *)clipPath;

@end
