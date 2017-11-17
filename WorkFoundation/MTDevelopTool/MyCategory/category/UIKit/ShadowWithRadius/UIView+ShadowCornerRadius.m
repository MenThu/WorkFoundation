//
//  UIView+ShadowCornerRadius.m
//  TestProxy
//
//  Created by MenThu on 2017/11/16.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import "UIView+ShadowCornerRadius.h"

@implementation UIView (ShadowCornerRadius)

- (UIView *)addShadowAndCornerRadius:(ShadowCornerRadius *)setting{
    if (![setting isKindOfClass:[ShadowCornerRadius class]]) {
        setting = [ShadowCornerRadius new];
        setting.cornerRadius = self.layer.cornerRadius;
        setting.isMask2BoundsOn = self.layer.masksToBounds;
        
        setting.shadowOffset = self.layer.shadowOffset;
        setting.shadowColor = [UIColor colorWithCGColor:self.layer.shadowColor];
        setting.shadowRadius = self.layer.shadowRadius;
        setting.shadowOpacity = self.layer.shadowOpacity;
    }
    self.layer.cornerRadius = setting.cornerRadius;
    self.layer.masksToBounds = YES;
    
    UIView *containerView = [[UIView alloc] initWithFrame:self.frame];
    containerView.layer.shadowOffset = setting.shadowOffset;
    containerView.layer.shadowColor = setting.shadowColor.CGColor;
    containerView.layer.shadowRadius = setting.shadowRadius;
    containerView.layer.shadowOpacity = setting.shadowOpacity;
    containerView.layer.cornerRadius = setting.cornerRadius;
    
    if ([self.superview isKindOfClass:[UIView class]]) {//调用视图已有父视图
        UIView *superView = self.superview;
        containerView.frame = self.frame;
        [superView addSubview:containerView];
        [self removeFromSuperview];
    }
    self.frame = containerView.bounds;
    [containerView addSubview:self];
    return containerView;
}

@end
