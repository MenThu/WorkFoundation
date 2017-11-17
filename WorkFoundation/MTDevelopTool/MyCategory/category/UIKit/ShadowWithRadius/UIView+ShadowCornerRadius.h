//
//  UIView+ShadowCornerRadius.h
//  TestProxy
//
//  Created by MenThu on 2017/11/16.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShadowCornerRadius.h"

@interface UIView (ShadowCornerRadius)

/**
 *  调用此方法，会默认视图的内容部分需要裁剪（设置MaskToBounds为YES）
 *  视图(调用者)会被设置圆角和MaskToBounds属性
 *  创建一个视图，对其增加阴影
 *  返回创建的视图
 **/
- (UIView *)addShadowAndCornerRadius:(ShadowCornerRadius *)setting;

@end
