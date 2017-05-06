//
//  UIView+Extensions.m
//  ZPM
//
//  Created by 陈宇 on 15/3/20.
//  Copyright (c) 2015年 陈宇. All rights reserved.
//

#import "UIView+Convenience.h"
#import "UIColor+HexColor.h"

@implementation UIView (Convenience)

#pragma mark - 属性set方法
- (void)setX:(CGFloat)x
{
    CGRect frame      = self.frame;
    frame.origin.x    = x;
    self.frame        = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame      = self.frame;
    frame.origin.y    = y;
    self.frame        = frame;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame      = self.frame;
    frame.origin      = origin;
    self.frame        = frame;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame      = self.frame;
    frame.size.width  = width;
    self.frame        = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame      = self.frame;
    frame.size.height = height;
    self.frame        = frame;
}

- (void)setSize:(CGSize)size
{
    CGRect frame      = self.frame;
    frame.size        = size;
    self.frame        = frame;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center    = self.center;
    center.x          = centerX;
    self.center       = center;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center    = self.center;
    center.y          = centerY;
    self.center       = center;
}

#pragma mark - 属性get方法
- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)cornerRectWith:(UIRectCorner)rectCorner
{
    UIBezierPath *maskPath  = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(5.f, 5.f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
}

- (UIImage *)snapshoot
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.layer.contentsScale);//[UIScreen mainScreen].scale
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshootImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshootImage;
}

- (void)hideAllMB{
    for (MBProgressHUD *subView in self.subviews) {
        if ([subView isKindOfClass:[MBProgressHUD class]]) {
            [subView hide:NO];
        }
    }
}

- (void)showMessage:(NSString *)message offset:(CGFloat)offset{
    //显示提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.tag = 1000;
    hud.userInteractionEnabled = YES;
    UITapGestureRecognizer *removeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove:)];
    [hud addGestureRecognizer:removeTap];
    hud.mode = MBProgressHUDModeText;
    
    if ([self isSet2DetailTextWith:message andFont:hud.labelFont]) {
        hud.detailsLabelText = message;
    }else{
        hud.labelText = message;
    }
    hud.margin = 10.f;
    hud.yOffset = offset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.f];
}

- (void)showMessageInMiddleOfView:(NSString *)message{
    [self showMessage:message offset:0];
}

- (BOOL)isSet2DetailTextWith:(NSString *)message andFont:(UIFont *)font{
    BOOL isSet2Detail;
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.text = message;
    label.numberOfLines = 0;
    CGSize maxSize = CGSizeMake(MAXFLOAT, font.lineHeight);
    CGSize fitSize = [label sizeThatFits:maxSize];
    if (fitSize.width >= MTScreenSize().width-20) {
        isSet2Detail = YES;
    }else{
        isSet2Detail = NO;
    }
    return isSet2Detail;
}

- (void)remove:(UITapGestureRecognizer *)tap{
    UIView *tapView = [tap view];
    MBProgressHUD *hud = (MBProgressHUD *)tapView;
    if ([hud isKindOfClass:[MBProgressHUD class]]) {
        [hud hide:YES];
    }
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (void)addShadowWith:(ShadowInfo *)info{
    self.clipsToBounds = NO;
    self.layer.shadowColor = [UIColor colorWithHex:info.colorHexStr].CGColor;
    self.layer.shadowRadius = info.shadowRadius;
    self.layer.shadowOffset = info.shadowOffset;
    self.layer.shadowOpacity = info.Opacity;
}

@end
