//
//  NSDate+Extension.m
//  TestStoryboard
//
//  Created by MenThu on 2016/11/24.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSString *)systemCurrentTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
    NSString *systemTime = [dateFormatter stringFromDate:currentDate];
    return systemTime;
}

@end
