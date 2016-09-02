//
//  MyTimer.h
//  TestRecord
//
//  Created by MenThu on 16/8/10.
//  Copyright © 2016年 官辉. All rights reserved.
//



#import <Foundation/Foundation.h>

typedef void(^TimerCount)(NSInteger timeCount);

@interface MyTimer : NSObject

+ (instancetype)customTimeInterval:(CGFloat)timer WithBlock:(TimerCount)block;

- (void)startTimer;
- (void)pauseTimer;
- (void)endTimer;

@end
