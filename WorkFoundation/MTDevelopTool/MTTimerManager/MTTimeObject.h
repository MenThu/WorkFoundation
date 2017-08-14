//
//  MTTimeObject.h
//  Test
//
//  Created by MenThu on 2017/8/11.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTTimeObject : NSObject

/**
 *  年
 **/
@property (nonatomic, strong) NSNumber *year;

/**
 *  月
 **/
@property (nonatomic, strong) NSNumber *month;

/**
 *  日
 **/
@property (nonatomic, strong) NSNumber *day;

/**
 *  时
 **/
@property (nonatomic, strong) NSNumber *hour;

/**
 *  分
 **/
@property (nonatomic, strong) NSNumber *min;

/**
 *  秒
 **/
@property (nonatomic, strong) NSNumber *sec;

/**
 *  星期几
 **/
@property (nonatomic, copy) NSString *weekDay;

@end
