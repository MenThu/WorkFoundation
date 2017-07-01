//
//  Calendar.h
//  artapp
//
//  Created by MenThu on 17/6/20.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarMonth.h"

@interface Calendar : UIView

/**
 *  初始化方法
 **/
- (instancetype)initWithWidth:(CGFloat)viewWidth;

/**
 *  状态(1展开/0折叠)
 **/
@property (nonatomic, assign) NSInteger foldStatus;

/**
 *  status表示当前日历表的状态
 *  0   折叠
 *  1   展开
 **/
@property (nonatomic, copy) void (^foldBlock) (NSInteger status);

/**
 *  当月行程
 **/
@property (nonatomic, strong) CalendarMonth *courseForMonth;

/**
 *  选择日期回调
 **/
@property (nonatomic, copy) void (^selectDate) (CalendarDay *day);

/**
 *  请求当月行程
 **/
@property (nonatomic, copy) void (^monthCourse) (CalendarMonth *month);

/**
 *  折叠时，展示的行数，默认一行
 **/
@property (nonatomic, assign) NSInteger lineForFoldStatus;

/**
 *  返回折叠(展开)的行高,在制定完lineForFoldStatus后调用
 **/
- (CGFloat)getHeight:(BOOL)isFold;

@end
