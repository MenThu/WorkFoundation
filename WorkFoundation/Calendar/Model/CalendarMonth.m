//
//  CalendarMonth.m
//  artapp
//
//  Created by MenThu on 17/6/20.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "CalendarMonth.h"

@implementation CalendarMonth

- (instancetype)init{
    if (self = [super init]) {
        self.selectLine = 0;
        self.isStatusFold = 0;
        self.isSetMonthCourse = NO;
    }
    return self;
}

@end
