//
//  MTTimerManager.h
//  Test
//
//  Created by MenThu on 2017/8/11.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTTimeObject.h"

@interface MTTimerManager : NSObject

kSingletonH

/**
 *  从1970开始的时间戳(单位秒)
 **/
- (void)Since1970:(NSTimeInterval)timeInterval rezult:(void (^)(MTTimeObject *dateObject))timeBlock;

/**
 *  从现在开始往后的秒
 **/
- (void)secondOffsetFromNow:(NSInteger)secondOffset rezult:(void (^)(MTTimeObject *dateObject))timeBlock;

/**
 *  从现在开始往后的分钟
 **/
- (void)minsOffsetFromNow:(NSInteger)secondOffset rezult:(void (^)(MTTimeObject *dateObject))timeBlock;

/**
 *  从今天开始的偏移量(单位天)
 **/
- (void)dayOffset:(NSInteger)offset rezult:(void (^)(MTTimeObject *dateObject))timeBlock;

@end
