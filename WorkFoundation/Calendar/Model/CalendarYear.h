//
//  CalendarYear.h
//  artapp
//
//  Created by MenThu on 17/6/20.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarMonth.h"

@interface CalendarYear : NSObject

@property (nonatomic, assign) NSInteger year;

/**
 *  daysForMonth一共有12个元素，分别代表每一个月
 **/
@property (nonatomic, strong) NSArray <CalendarMonth *> *months;

@end
