//
//  CalendarWeekCell.m
//  artapp
//
//  Created by MenThu on 17/6/20.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "CalendarWeekCell.h"

@interface CalendarWeekCell ()

@property (nonatomic, weak) UILabel *week;
@property (nonatomic, assign) NSInteger weekDay;

@end

@implementation CalendarWeekCell

- (void)customView{
    UILabel *week = [UILabel new];
    week.font = [UIFont systemFontOfSize:13];
    week.textAlignment = NSTextAlignmentCenter;
    week.textColor = [UIColor blackColor];
    [self.contentView addSubview:(_week = week)];
    MTWeakSelf;
    [week mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
}

- (void)updateCustomView{
    NSNumber *weekDay = (NSNumber *)self.cellModel;
    self.weekDay = weekDay.integerValue;
}

- (void)setWeekDay:(NSInteger)weekDay{
    _weekDay = weekDay;
    NSString *weekDayString = @"";
    switch (weekDay) {
        case 1:
            weekDayString = @"一";
            break;
        case 2:
            weekDayString = @"二";
            break;
        case 3:
            weekDayString = @"三";
            break;
        case 4:
            weekDayString = @"四";
            break;
        case 5:
            weekDayString = @"五";
            break;
        case 6:
            weekDayString = @"六";
            break;
        case 7:
            weekDayString = @"日";
            break;
        default:
            break;
    }
    self.week.text = weekDayString;
}

@end
