//
//  MTTimer.h
//  TestRecord
//
//  Created by MenThu on 16/8/10.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import "MTTimerSetting.h"

typedef void(^TimerCallBack)(NSInteger callCount, CGFloat passTime);

@interface MTTimer : NSObject

/**
 *  用setting初始化一个定时器
 *  callBack
 *      callCount 当前回调次数
 *      passTime  过去的时间
 **/
- (instancetype)initWithSetting:(MTTimerSetting *)setting
                       callback:(TimerCallBack)callBack;

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
