//
//  UIButton+Custom.m
//  TestCocoapod
//
//  Created by MenThu on 16/8/23.
//  Copyright © 2016年 官辉. All rights reserved.
//

#define Space 5.f

#import "UIButton+Custom.h"
#import "UIView+Convenience.h"

@implementation UIButton (Custom)

- (void)buttonDisplayStyle:(ButtomStyle)buttomStyle
{
    self.backgroundColor = [UIColor yellowColor];
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    switch (buttomStyle) {
        case ImageRight:
        {
            [self image2Right];
        }
            break;
        case ImageUp:
        {
            [self image2Top];
        }
            break;
        case ImageBottom:
        {
            [self image2Bottom];
        }
            break;
            
        default:
            break;
    }
}

- (void)image2Right
{
    CGFloat imageWidth = self.imageView.width;
    CGFloat labelWidth = self.titleLabel.width;
    
    CGFloat imageHeight = self.imageView.height;
    CGFloat labelHeight = self.titleLabel.height;
    
    CGFloat btnWidth = self.width;
    CGFloat btnHeight = self.height;
    
    CGFloat labelHorizonMoveSpace = btnWidth/2 - (imageWidth + labelWidth)/2 - imageWidth - Space/2;
    CGFloat imageHorizonMoveSpace = btnWidth/2 - (imageWidth + labelWidth)/2 + labelWidth + Space/2;


    CGFloat labelVerMoveSpace = btnHeight/2 - labelHeight/2;
    CGFloat imageVerMoveSpace = btnHeight/2 - imageHeight/2;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageVerMoveSpace, imageHorizonMoveSpace, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(labelVerMoveSpace, labelHorizonMoveSpace, 0, 0);
}


- (void)image2Top
{
    CGFloat imageWidth = self.imageView.width;
    
    NSString *labelText = self.titleLabel.text;
    CGFloat testWidth = [labelText boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size.width;
    
    CGFloat labelWidth = (self.titleLabel.width < testWidth ? testWidth : self.titleLabel.width);
    
    CGFloat imageHeight = self.imageView.height;
    CGFloat labelHeight = self.titleLabel.height;
    
    CGFloat btnWidth = self.width;
    CGFloat btnHeight = self.height;
    
    CGFloat labelHorizonMoveSpace = btnWidth/2  - (imageWidth + labelWidth/2) ;
    
    CGFloat imageHorizonMoveSpace = btnWidth/2 - imageWidth/2 ;
    
    
    CGFloat labelVerMoveSpace = btnHeight/2 - (labelHeight + imageHeight)/2 + imageHeight + Space/2;
    CGFloat imageVerMoveSpace = btnHeight/2 - (labelHeight + imageHeight)/2 - Space/2;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageVerMoveSpace, imageHorizonMoveSpace, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(labelVerMoveSpace, labelHorizonMoveSpace, 0, 0);
}

- (void)image2Bottom
{
    CGFloat imageWidth = self.imageView.width;
    
    NSString *labelText = self.titleLabel.text;
    CGFloat testWidth = [labelText boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size.width;
    
    CGFloat labelWidth = (self.titleLabel.width < testWidth ? testWidth : self.titleLabel.width);
    
    CGFloat imageHeight = self.imageView.height;
    CGFloat labelHeight = self.titleLabel.height;
    
    CGFloat btnWidth = self.width;
    CGFloat btnHeight = self.height;
    
    CGFloat labelHorizonMoveSpace = btnWidth/2  - (imageWidth + labelWidth/2) ;
    CGFloat imageHorizonMoveSpace = btnWidth/2 - imageWidth/2 ;
    
    
    CGFloat labelVerMoveSpace = btnHeight/2 - (labelHeight + imageHeight)/2  - Space/2;
    CGFloat imageVerMoveSpace = btnHeight/2 - (labelHeight + imageHeight)/2 + labelHeight + Space/2;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageVerMoveSpace, imageHorizonMoveSpace, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(labelVerMoveSpace, labelHorizonMoveSpace, 0, 0);
}

@end
