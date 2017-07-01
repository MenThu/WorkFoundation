//
//  CalendarMonthCell.h
//  artapp
//
//  Created by MenThu on 17/6/20.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "MTBaseCollectionCell.h"
#import "CalendarDay.h"
#define LineHeight 45.f

@interface CalendarMonthCell : MTBaseCollectionCell

/**
 *  选择日期的回调
 **/
@property (nonatomic, copy) void (^selectDate) (CalendarDay *day);

@end
