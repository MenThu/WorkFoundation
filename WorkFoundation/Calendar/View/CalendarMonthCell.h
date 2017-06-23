//
//  CalendarMonthCell.h
//  artapp
//
//  Created by MenThu on 17/6/20.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "MTBaseCollectionCell.h"
#import "CalendarDay.h"
#define LineHeight 50.f

@interface CalendarMonthCell : MTBaseCollectionCell

@property (nonatomic, copy) void (^selectDate) (CalendarDay *day);
- (void)setFoldStatus:(NSInteger)isFold;

@end
