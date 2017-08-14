//
//  MyTimer.m
//  TestRecord
//
//  Created by MenThu on 16/8/10.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "MTTimer.h"

@interface MTTimer ()

@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) MTTimerInfo *timerInfo;
@property (nonatomic, assign) CGFloat timerCount;
@property (nonatomic, assign) BOOL isTimerOn;

@end

@implementation MTTimer

+ (MTTimer *)createWith:(MTTimerInfo *)timerInfo{
    MTTimer *timerManager = [MTTimer new];
    timerManager.timerInfo = timerInfo;
    timerManager.timerCount = 0;
    __weak MTTimer* weakTimer = timerManager;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timerInfo.timeInterval target:weakTimer selector:@selector(countFunc) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    timerManager.timer = timer;
    [timerManager.timer setFireDate:[NSDate distantFuture]];
    timerManager.isTimerOn = NO;
    return timerManager;
}

- (void)startTimer
{
    if (self.isTimerOn) {
        return;
    }
    
    CGFloat addTimerInterval = 0;
    if (self.timerInfo.isInstantStart == NO) {
        addTimerInterval = self.timerInfo.timeInterval;
    }
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:addTimerInterval]];
    self.isTimerOn = YES;
}


- (void)pauseTimer
{
    if (!self.isTimerOn) {
        return;
    }
    [self.timer setFireDate:[NSDate distantFuture]];
    self.isTimerOn = NO;
}

- (void)endTimer
{
    if (![self.timer isValid]) {
        return ;
    }
    [self.timer invalidate];
    self.timer = nil;
    self.isTimerOn = NO;
}

- (void)countFunc
{
    ++self.timerCount;
    if (self.timerInfo.countBlock) {
        self.timerInfo.countBlock(self.timerCount * self.timerInfo.timeInterval);
    }
}

- (void)dealloc
{
    NSLog(@"%@  die",self);
}

@end
