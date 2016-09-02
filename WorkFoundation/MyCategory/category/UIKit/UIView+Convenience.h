//
//  UIView+Extensions.h
//  ZPM
//
//  Created by 陈宇 on 15/3/20.
//  Copyright (c) 2015年 陈宇. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end
