//
//  Calendar.h
//  artapp
//
//  Created by MenThu on 17/6/20.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDay.h"

@interface Calendar : UIView

/**
 *  初始化方法
 **/
- (instancetype)initWithWidth:(CGFloat)viewWidth;

/**
 *  0   折叠
 *  1   展开
 **/
@property (nonatomic, copy) void (^foldBlock) (NSInteger status);

/**
 *  有待办事项的事项
 *  matterArray的天数必修在同一个月
 **/
@property (nonatomic, strong) NSArray <CalendarDay *> *matterArray;

/**
 *  选择日期回调
 **/
@property (nonatomic, copy) void (^selectDate) (CalendarDay *day);

/**
 *  状态(展开/折叠)
 **/
@property (nonatomic, assign) NSInteger foldStatus;

/**
 *  折叠时，展示的行数，默认一行
 **/
@property (nonatomic, assign) NSInteger lineForFoldStatus;

/**
 *  返回折叠(展开)的行高,在制定完lineForFoldStatus后调用
 **/
- (CGFloat)getHeight:(BOOL)isFold;

@end
