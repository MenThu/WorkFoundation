//
//  UIView+CornerRadius.m
//  CornerRadiusText
//
//  Created by 雷琦玮 on 16/2/29.
//  Copyright © 2016年 com.BlueMobi.Lqw. All rights reserved.
//

#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}


-(void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor: self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

@end
