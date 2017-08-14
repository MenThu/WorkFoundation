//
//  MTTimer.h
//  TestRecord
//
//  Created by MenThu on 16/8/10.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import "MTTimerInfo.h"

@interface MTTimer : NSObject

/**
 *  构造一个定时器
 **/
+ (MTTimer *)createWith:(MTTimerInfo *)timerInfo;

/**
 *  开始一个定时器
 **/
- (void)startTimer;

/**
 *  暂停一个定时器（可以再开始）
 **/
- (void)pauseTimer;

/**
 *  销毁一个定时器
 **/
- (void)endTimer;

@end
