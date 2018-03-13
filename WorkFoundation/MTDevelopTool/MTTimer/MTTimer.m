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
@property (nonatomic, strong) MTTimerSetting *timerInfo;
@property (nonatomic, assign) NSUInteger timerCount;
@property (nonatomic, assign) BOOL isTimerOn;
@property (nonatomic, copy) TimerCallBack callBack;

@end

@implementation MTTimer

- (instancetype)initTimerWithInterval:(CGFloat)interval
                        isStartAcOnce:(BOOL)yesOrNo
                        timerCallBack:(TimerCallBack)callBack{
    if (self = [super init]) {
        //构造参数
        MTTimerSetting *timerInfo = [MTTimerSetting new];
        timerInfo.isInstantStart = yesOrNo;
        timerInfo.timeInterval = interval;
        
        self.timerInfo = timerInfo;
        self.callBack = callBack;
        self.timerCount = 0;
        __weak typeof(self) weakSelf = self;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInfo.timeInterval target:weakSelf selector:@selector(countFunc) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
        [self.timer setFireDate:[NSDate distantFuture]];
        self.isTimerOn = NO;
    }
    return self;
}

- (instancetype)initWithSetting:(MTTimerSetting *)setting callback:(TimerCallBack)callBack{
    if (self = [super init]) {
        self.callBack = callBack;
        self.timerInfo = setting;
        self.timerCount = 0;
        __weak typeof(self) weakSelf = self;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInfo.timeInterval target:weakSelf selector:@selector(countFunc) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
        [self.timer setFireDate:[NSDate distantFuture]];
        self.isTimerOn = NO;
    }
    return self;
}

- (void)startTimer{
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


- (void)pauseTimer{
    if (!self.isTimerOn) {
        return;
    }
    [self.timer setFireDate:[NSDate distantFuture]];
    self.isTimerOn = NO;
}

- (void)endTimer{
    if (![self.timer isValid]) {
        return ;
    }
    [self.timer invalidate];
    self.timer = nil;
    self.isTimerOn = NO;
}

- (void)countFunc{
    ++self.timerCount;
    if (self.callBack) {
        self.callBack(self.timerCount, self.timerCount * self.timerInfo.timeInterval);
    }
}

- (void)dealloc{
    NSLog(@"%@  die",self);
}

@end
