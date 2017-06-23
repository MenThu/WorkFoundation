//
//  CalendarDay.h
//  artapp
//
//  Created by MenThu on 17/6/20.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarDay : NSObject

/**
 *  年
 **/
@property (nonatomic, assign) NSInteger year;

/**
 *  月份
 **/
@property (nonatomic, assign) NSInteger month;

/**
 *  日期
 **/
@property (nonatomic, assign)NSInteger day;

/**
 *  1~7 表示星期一到星期日
 **/
@property (nonatomic, assign) NSInteger weekDay;

/**
 *  -1  上一个月
 *  0   当月
 *  1   下一个月
 **/
@property (nonatomic, assign) NSInteger previouOrCurrentOrNext;

/**
 *  是否选中
 **/
@property (nonatomic, assign) BOOL isSelect;

/**
 *  是否为当天
 **/
@property (nonatomic, assign) BOOL isNow;

/**
 *  是否有待办事项
 *  0 没有
 *  1 有
 **/
@property (nonatomic, assign) NSInteger isHaveMatter;

@end
