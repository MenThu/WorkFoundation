//
//  CalendarMonth.h
//  artapp
//
//  Created by MenThu on 17/6/20.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarDay.h"

@interface CalendarMonth : NSObject

/**
 *  年份
 **/
@property (nonatomic, assign) NSInteger year;

/**
 *  月份
 **/
@property (nonatomic, assign) NSInteger month;

/**
 *  当月共有几天(应该和days.count相同)
 **/
@property (nonatomic, assign) NSInteger totalMonthDay;

/**
 *  状态(展开/折叠)
 *  0 折叠
 *  1 展开
 **/
@property (nonatomic, assign) BOOL isStatusFold;

/**
 *  折叠状态下，月默认展示第0行
 **/
@property (nonatomic, assign) NSInteger displayLineForFoldStatus;

/**
 *  存储当月的每一天的数据
 **/
@property (nonatomic, strong) NSArray <CalendarDay *> *days;

@end
