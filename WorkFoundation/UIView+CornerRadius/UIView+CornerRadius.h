//
//  UIView+CornerRadius.h
//  CornerRadiusText
//
//  Created by 雷琦玮 on 16/2/29.
//  Copyright © 2016年 com.BlueMobi.Lqw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CornerRadius)
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@end
