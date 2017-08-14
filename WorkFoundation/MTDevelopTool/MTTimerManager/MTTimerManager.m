//
//  MTTimerManager.m
//  Test
//
//  Created by MenThu on 2017/8/11.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import "MTTimerManager.h"

@interface MTTimerManager ()


@end

@implementation MTTimerManager

kSingletonM

/**
 *  计算距离1970往后timeInterval的时间
 **/
- (void)Since1970:(NSTimeInterval)timeInterval rezult:(void (^)(MTTimeObject *dateObject))timeBlock{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    NSNumber *year= @(comps.year);
    NSNumber *month= @(comps.month);
    NSNumber *day= @(comps.day);
    NSNumber *hour = @(comps.hour);
    NSNumber *minute = @(comps.minute);
    NSNumber *second = @(comps.second);
    NSArray *arrayWeek= @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSString *weekDay = arrayWeek[comps.weekday-1];
    
    MTTimeObject *timeObject = [MTTimeObject new];
    timeObject.year = year;
    timeObject.month = month;
    timeObject.day = day;
    
    timeObject.hour = hour;
    timeObject.min = minute;
    timeObject.sec = second;
    
    timeObject.weekDay = weekDay;
    
    if (timeBlock) {
        timeBlock(timeObject);
    }
}

/**
 *  从现在开始往后的秒
 **/
- (void)secondOffsetFromNow:(NSInteger)secondOffset rezult:(void (^)(MTTimeObject *dateObject))timeBlock{
    NSDate *date = [NSDate date];
    NSTimeInterval currentTime = [date timeIntervalSince1970];
    [self Since1970:currentTime+secondOffset rezult:^(MTTimeObject *dateObject) {
        if (timeBlock) {
            timeBlock(dateObject);
        }
    }];
}

/**
 *  从现在开始往后的分钟
 **/
- (void)minsOffsetFromNow:(NSInteger)minsOffset rezult:(void (^)(MTTimeObject *dateObject))timeBlock{
    NSDate *date = [NSDate date];
    NSTimeInterval currentTime = [date timeIntervalSince1970];
    [self Since1970:currentTime+minsOffset*60 rezult:^(MTTimeObject *dateObject) {
        if (timeBlock) {
            timeBlock(dateObject);
        }
    }];
}

/**
 *  从今天开始的偏移量(单位天)
 **/
- (void)dayOffset:(NSInteger)offset rezult:(void (^)(MTTimeObject *dateObject))timeBlock{
    NSDate *date = [NSDate date];
    NSTimeInterval currentTime = [date timeIntervalSince1970];
    NSTimeInterval timeOffsetFromNow = 24 * 60 * 60 * offset;
    [self Since1970:currentTime+timeOffsetFromNow rezult:^(MTTimeObject *dateObject) {
        if (timeBlock) {
            timeBlock(dateObject);
        }
    }];
}

@end
