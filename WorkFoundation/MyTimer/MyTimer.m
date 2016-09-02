//
//  MyTimer.m
//  TestRecord
//
//  Created by MenThu on 16/8/10.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "MyTimer.h"

@interface MyTimer ()

@property (nonatomic, strong) NSTimer* thisTimer;
@property (nonatomic, copy) TimerCount timeBlock;
@property (nonatomic, assign) NSInteger countSec;
@property (nonatomic, assign) NSInteger isOn;

@end

@implementation MyTimer


+ (instancetype)customTimeInterval:(CGFloat)timer WithBlock:(TimerCount)block
{
    

    MyTimer *repeatCount = [MyTimer new];
    __weak MyTimer* weakTarget = repeatCount;
    repeatCount.timeBlock = block;
    repeatCount.countSec = 0;
    repeatCount.thisTimer = [NSTimer scheduledTimerWithTimeInterval:timer target:weakTarget selector:@selector(countFunc) userInfo:nil repeats:YES];
    [repeatCount.thisTimer setFireDate:[NSDate distantFuture]];
    repeatCount.isOn = NO;
    return repeatCount;
}

- (void)startTimer
{
    if (self.isOn) {
        return;
    }
    
    [self.thisTimer setFireDate:[NSDate distantPast]];
    self.isOn = YES;
}


- (void)pauseTimer
{
    if (!self.isOn) {
        return;
    }
    [self.thisTimer setFireDate:[NSDate distantFuture]];
    self.isOn = NO;
}

- (void)endTimer
{
    if (![self.thisTimer isValid]) {
        return ;
    }
    [self.thisTimer invalidate];
    self.thisTimer = nil;
    self.isOn = NO;
}

- (void)countFunc
{
    NSLog(@"countFunc");
    if (self.timeBlock) {
        self.timeBlock(++self.countSec);
    }
}

- (void)dealloc
{
    NSLog(@"%@  die",self);
}

@end
