//
//  MTTimerSetting.m
//  test
//
//  Created by MenThu on 17/6/2.
//  Copyright © 2017年 darcy. All rights reserved.
//

#import "MTTimerSetting.h"

@implementation MTTimerSetting

- (instancetype)init{
    if (self = [super init]) {
        self.isInstantStart = YES;
        self.timeInterval = 1.f;
    }
    return self;
}

@end
