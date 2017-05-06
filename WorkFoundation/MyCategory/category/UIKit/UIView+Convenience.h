//
//  UIView+Extensions.h
//  ZPM
//
//  Created by 陈宇 on 15/3/20.
//  Copyright (c) 2015年 陈宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShadowInfo.h"

@interface UIView (Convenience)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

/**
 *  改变UIView制定几个角圆角
 */
- (void)cornerRectWith:(UIRectCorner)rectCorner;

/**
 *  获得当前视图的快照
 *
 *  @return 当前视图快照图片
 */
- (UIImage *)snapshoot;

/**
 *  message 要显示的信息
 *  offset  偏移量，方向沿y轴正方向向下
 **/
- (void)showMessage:(NSString *)message offset:(CGFloat)offset;

/**
 *  在视图中间显示提示信息
 **/
- (void)showMessageInMiddleOfView:(NSString *)message;

/**
 *  删除所有子视图
 **/
- (void)removeAllSubviews;

/**
 *  删除所有MB提示视图
 **/
- (void)hideAllMB;

/**
 *  增加阴影
 *  该方法会关闭clipsToBounds属性
 **/
- (void)addShadowWith:(ShadowInfo *)info;

@end
