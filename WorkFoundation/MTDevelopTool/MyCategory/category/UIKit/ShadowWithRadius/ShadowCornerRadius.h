//
//  ShadowCornerRadius.h
//  TestProxy
//
//  Created by MenThu on 2017/11/16.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShadowCornerRadius : NSObject

/**
 *  圆角大小
 **/
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 *  是否设置MaskToBounds为YES
 *  默认为YES
 **/
@property (nonatomic, assign) BOOL isMask2BoundsOn;

/**
 *  阴影偏移量
 **/
@property (nonatomic, assign) CGSize shadowOffset;

/**
 *  阴影颜色
 **/
@property (nonatomic, strong) UIColor *shadowColor;

/**
 *  阴影半径
 **/
@property (nonatomic, assign) CGFloat shadowRadius;

/**
 *  阴影透明度
 **/
@property (nonatomic, assign) CGFloat shadowOpacity;

@end
