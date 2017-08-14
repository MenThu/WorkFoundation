//
//  MTDatePickerView.m
//  MTTest
//
//  Created by MenThu on 2017/5/3.
//  Copyright © 2017年 官辉. All rights reserved.
//

#import "MTDatePickerView.h"


@interface MTDatePickerView ()

@property (nonatomic, assign) NSInteger currentYear;
@property (nonatomic, assign) NSInteger currentMonth;
@property (nonatomic, assign) NSInteger currentDay;

@property (nonatomic, assign) NSInteger currentHour;
@property (nonatomic, assign) NSInteger currentMin;

@property (nonatomic, strong) NSMutableArray <NSNumber *> *selectMinArray;
@property (nonatomic, copy) void (^finishBlock) (MTTimeObject *timeObject);

@end

@implementation MTDatePickerView

- (instancetype)initWithFrame:(CGRect)frame finish:(void (^) (MTTimeObject *timeObject))finishBlock{
    if (self = [super initWithFrame:frame]) {
        [self prepareDate];
        MTWeakSelf;
        self.finishBlock = finishBlock;
        self.finishSelect = ^(NSArray <NSNumber *> *selectIndex){
            if (weakSelf.finishBlock && [selectIndex isExist]) {
                NSArray <ItemModel *> *yearArray = weakSelf.model.pickerSource;
                //年
                NSInteger yearSelectIndex = selectIndex[0].integerValue;
                NSInteger year = yearArray[yearSelectIndex].itemValue.integerValue;
                NSArray <ItemModel *> *monthArray = yearArray[yearSelectIndex].nextArray;
                
                //月
                NSInteger monthSelectIndex = selectIndex[1].integerValue;
                NSInteger month = monthArray[monthSelectIndex].itemValue.integerValue;
                NSArray <ItemModel *> *dayArray = monthArray[monthSelectIndex].nextArray;
                
                //日
                NSInteger daySelectIndex = selectIndex[2].integerValue;
                NSInteger day = dayArray[daySelectIndex].itemValue.integerValue;
                NSArray <ItemModel *> *hourArray = dayArray[daySelectIndex].nextArray;
                
                //时
                NSInteger hourSelectIndex = selectIndex[3].integerValue;
                NSInteger hour = hourArray[hourSelectIndex].itemValue.integerValue;
                NSArray <ItemModel *> *minArray = hourArray[hourSelectIndex].nextArray;
                
                //分
                NSInteger minSelectIndex = selectIndex[4].integerValue;
                NSInteger min = minArray[minSelectIndex].itemValue.integerValue;
                
                MTTimeObject *timeObject = [[MTTimeObject alloc] init];
                timeObject.year = @(year);
                timeObject.month = @(month);
                timeObject.day = @(day);
                timeObject.hour = @(hour);
                timeObject.min = @(min);
                weakSelf.finishBlock(timeObject);
            }
        };
    }
    return self;
}

- (void)prepareDate{
    MTWeakSelf;
    [[MTTimerManager sharedInstance] dayOffset:0 rezult:^(MTTimeObject *dateObject) {
        weakSelf.currentYear = dateObject.year.integerValue;
        weakSelf.currentMonth = dateObject.month.integerValue;
        weakSelf.currentDay = dateObject.day.integerValue;
        weakSelf.currentHour = dateObject.hour.integerValue;
        weakSelf.currentMin = dateObject.min.integerValue;
        
        
        //生成分钟的Array
        weakSelf.selectMinArray = [NSMutableArray array];
        for (NSInteger min = 0; min <= 55; min += 5) {
            [weakSelf.selectMinArray addObject:@(min)];
        }
        
        MTTimeObject *year = [MTTimeObject new];
        year.year = @(weakSelf.currentYear);
        NSArray <ItemModel *> *source = [self getYearNextArrayWithStartYear:year offset:2];
        MTPickerModel *model = [MTPickerModel new];
        model.pickerTitle = @"预约时间";
        model.pickerSource = source;
        weakSelf.model = model;
    }];
}

/**
 *  获取year的array
 **/
- (NSMutableArray <ItemModel *> *)getYearNextArrayWithStartYear:(MTTimeObject *)timeObject offset:(NSInteger)distance{
    NSMutableArray *yearArray = [NSMutableArray array];
    NSInteger startYear = timeObject.year.integerValue;
    for (NSInteger year = startYear; year < startYear + distance; year ++) {
        ItemModel *yearModel = [ItemModel new];
        yearModel.itemName = [NSString stringWithFormat:@"%d年", (int)year];
        yearModel.itemValue = @(year);
        MTTimeObject *yearObject = [MTTimeObject new];
        yearObject.year = @(year);
        yearModel.nextArray = [self getMonthWith:yearObject];
        if ([yearModel.nextArray isExist]) {
            [yearArray addObject:yearModel];
        }
    }
    return yearArray;
}

/**
 *  根据年获取月的array
 **/
- (NSMutableArray <ItemModel *> *)getMonthWith:(MTTimeObject *)timeObject{
    NSMutableArray *monthArray = [NSMutableArray array];
    NSInteger startMonth;
    NSInteger year = timeObject.year.integerValue;
    if (year == self.currentYear) {
        startMonth = self.currentMonth;
    }else{
        startMonth = 1;
    }
    for (NSInteger month = startMonth; month < 13; month ++) {
        ItemModel *monthModel = [ItemModel new];
        monthModel.itemValue = @(month);
        monthModel.itemName = [NSString stringWithFormat:@"%d月", (int)month];
        MTTimeObject *yearMonthObject = [MTTimeObject new];
        yearMonthObject.year = @(year);
        yearMonthObject.month = @(month);
        monthModel.nextArray = [self getDayWith:yearMonthObject];
        if ([monthModel.nextArray isExist]) {
            [monthArray addObject:monthModel];
        }
    }
    return monthArray;
}

/**
 *  根据年,月获取天的array
 **/
- (NSMutableArray <ItemModel *> *)getDayWith:(MTTimeObject *)timeObject{
    NSInteger startDay;
    NSInteger year = timeObject.year.integerValue;
    NSInteger month = timeObject.month.integerValue;
    if (year == self.currentYear && month == self.currentMonth) {
        startDay = self.currentDay;
    }else{
        startDay = 1;
    }
    NSInteger fullDay = [self calculateDayWithMonthAndYear:month year:year]+1;
    NSMutableArray *dayArray = [NSMutableArray array];
    for (NSInteger day = startDay; day < fullDay; day ++) {
        ItemModel *dayModel = [ItemModel new];
        dayModel.itemValue = @(day);
        dayModel.itemName = [NSString stringWithFormat:@"%d号", (int)day];
        MTTimeObject *yearMonthDayObject = [MTTimeObject new];
        yearMonthDayObject.year = @(year);
        yearMonthDayObject.month = @(month);
        dayModel.nextArray = [self getHourWith:yearMonthDayObject];
        if ([dayModel.nextArray isExist]) {
            [dayArray addObject:dayModel];
        }
    }
    return dayArray;
}

/**
 *  根据年,月,天获取小时的array
 **/
- (NSMutableArray <ItemModel *> *)getHourWith:(MTTimeObject *)timeObject{
    NSInteger year = timeObject.year.integerValue;
    NSInteger month = timeObject.month.integerValue;
    NSInteger day = timeObject.day.integerValue;
    NSInteger startHour;
    if (day == self.currentDay && month == self.currentMonth && year == self.currentYear) {
        startHour = self.currentHour;
    }else{
        startHour = 0;
    }
    NSMutableArray *hourArray = [NSMutableArray array];
    for (NSInteger hour = startHour; hour < 24; hour ++) {
        ItemModel *hourModel = [ItemModel new];
        hourModel.itemValue = @(hour);
        hourModel.itemName = [NSString stringWithFormat:@"%d点", (int)hour];
        MTTimeObject *yearMonthDayHourObject = [MTTimeObject new];
        yearMonthDayHourObject.year = @(year);
        yearMonthDayHourObject.month = @(month);
        yearMonthDayHourObject.day = @(day);
        yearMonthDayHourObject.hour = @(hour);
        hourModel.nextArray = [self getMinWith:yearMonthDayHourObject];
        if ([hourModel.nextArray isExist]) {
            //每一个小时的55分以后，这个小时已经不能预约直播了,只能从下一个小时开始
            //比如,10:55(不包括)开始，10点已经不能预约直播了，只能从11点开始
            [hourArray addObject:hourModel];
        }
    }
    return hourArray;
}

/**
 *  根据年,月,天,小时获取分钟的array
 **/
- (NSMutableArray <ItemModel *> *)getMinWith:(MTTimeObject *)timeObject{
    NSInteger year = timeObject.year.integerValue;
    NSInteger month = timeObject.month.integerValue;
    NSInteger day = timeObject.day.integerValue;
    NSInteger hour = timeObject.hour.integerValue;
    
    //最快只能预约当前时间往后五分钟的
    //分钟间隔为5分钟一轮(只是为了不让用户滑动太多)
    NSInteger startMin;
    if (year == self.currentYear && month == self.currentMonth && day == self.currentDay && hour == self.currentHour) {
        startMin = self.currentMin + 5;
        if (startMin % 5 != 0) {
            //并没有落在self.selectMinArray的区间点上
            //取右侧最近分钟 例如startMin=13，则将startMin赋值为15;
            NSInteger count = 0;
            while (startMin > 5) {
                count ++;
                startMin -= 5;
            }
            startMin = 5 * (count+1);
        }
        if (startMin > 55) {
            //准备当前时间的分钟列数据源，发现这一个小时已经不能预约了
            return nil;
        }
    }else{
        startMin = 0;
    }
    NSInteger perOffset = 5;
    NSMutableArray *minArray = [NSMutableArray array];
    for (NSInteger min = startMin; min < 60; min += perOffset) {
        ItemModel *minModel = [ItemModel new];
        minModel.itemValue= @(min);
        minModel.itemName = [NSString stringWithFormat:@"%d分",(int)min];
        [minArray addObject:minModel];
    }
    return minArray;
}

/**
 *  根据年月，计算每个月的天数
 **/
- (NSInteger)calculateDayWithMonthAndYear:(NSInteger)month year:(NSInteger)year{
    /**
     *  1,3,5,7,8,10,12 这几月永远31天
     *  2月平年28天，闰年（一般年份能整除4但是不能被100整除的是闰年，）29天
     *  其他月份30天
     **/
    NSInteger day = 0;
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
        {
            day = 31;
        }
            break;
        case 4:
        case 6:
        case 9:
        case 11:
        {
            day = 30;
        }
            break;
        case 2:
        {
            //查看是否为闰年
            if (year % 4 == 0 && !(year % 100 == 0)) {
                //闰年
                day = 29;
            }else{
                day = 28;
            }
        }
            break;
        default:
            break;
    }
    return day;
}

@end
