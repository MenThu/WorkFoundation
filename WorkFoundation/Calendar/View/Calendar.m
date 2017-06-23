//
//  Calendar.m
//  artapp
//
//  Created by MenThu on 17/6/20.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "Calendar.h"
#import "CalendarYear.h"
#import "CalendarMonthCell.h"

@interface Calendar ()

/**
 *  日期Label
 **/
@property (nonatomic, weak) UILabel *dateLabel;

/**
 *  日期Label的高度
 **/
@property (nonatomic, assign) CGFloat dateLabelHeight;

/**
 *  展开收起状态Label
 **/
@property (nonatomic, weak) UILabel *statusLabel;

/**
 *  周视图
 **/
@property (nonatomic, weak) MTBaseCollectionView *weekView;

/**
 *  周视图的数据源
 **/
@property (nonatomic, strong) NSArray <NSNumber *> *weekArray;

/**
 *  周视图的高度
 **/
@property (nonatomic, assign) CGFloat weekViewHeight;

/**
 *  月份视图
 **/
@property (nonatomic, weak) MTBaseCollectionView *monthView;

/**
 *  日历视图的高度
 **/
@property (nonatomic, assign) CGFloat monthViewHeight;

/**
 *  日历空间的间隙
 **/
@property (nonatomic, assign) CGFloat space;

/**
 *  日历视图的宽度
 **/
@property (nonatomic, assign) CGFloat viewWidth;

/**
 *  日历所需要的数据
 **/
@property (nonatomic, strong) NSArray <CalendarMonth *> *dataArray;

/**
 *  系统的当前时间
 **/
@property (nonatomic, strong) DateCompentObject *currentTime;

/**
 *  日历第一次出现的时候，需要滚动到现在的时间
 **/
@property (nonatomic, assign) BOOL isSet2Middle;

/**
 *  当前月在数组中的下表
 **/
@property (nonatomic, assign) NSInteger indexOfCurrentMonth;

/**
 *  一行日历表的高度
 **/
@property (nonatomic, assign) CGFloat lineHeightOfDayCell;



@end

@implementation Calendar

- (instancetype)initWithWidth:(CGFloat)viewWidth{
    if (self = [super init]) {
        self.viewWidth = viewWidth;
        [self prepareData];
        [self configView];
    }
    return self;
}

- (void)prepareData{
    self.foldStatus = 0;
    self.isSet2Middle = NO;
    self.lineForFoldStatus = 1;
    self.weekArray = @[@(1), @(2), @(3), @(4), @(5), @(6), @(7)];
    self.space = 5.f;
    self.dateLabelHeight = 30.f;
    self.dataArray = [self prepareDataForMonthView];
}

- (CGFloat)getHeight:(BOOL)isFold{
    NSInteger line = (isFold == YES ? self.lineForFoldStatus: 6);
    CGFloat height = self.dateLabelHeight + self.weekViewHeight + self.lineHeightOfDayCell*line + self.space * 4;
    return height;
}

- (void)configView{
    MTWeakSelf;
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    //title
    UILabel *dateLabel = [UILabel new];
    dateLabel.userInteractionEnabled = YES;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [UIFont systemFontOfSize:13];
    dateLabel.textColor = [UIColor darkTextColor];
    dateLabel.text = @"日历表";
    UITapGestureRecognizer *foldOrUnfoldAct = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeFoldStatus)];
    [dateLabel addGestureRecognizer:foldOrUnfoldAct];
    [self addSubview:(_dateLabel = dateLabel)];
    
    //展开(收起)
    UILabel *statusLabel = [UILabel new];
    statusLabel.userInteractionEnabled = NO;
    statusLabel.text = @"展开";
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.font = [UIFont systemFontOfSize:12];
    statusLabel.textColor = [UIColor grayColor];
    [self addSubview:(_statusLabel = statusLabel)];
    
    //星期
    MTBaseCollectionView *weekView = [[MTBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, MTScreenSize().width, 500)];
    weekView.cellClassName = @"CalendarWeekCell";
    weekView.isFromXib = NO;
    weekView.numofLine = 1;
    weekView.itemWidth = (self.viewWidth-2*self.space) / self.weekArray.count;
    weekView.itemHeight = 30.f;
    [weekView startLayout];
    self.weekViewHeight = [weekView getmtBaseHeight];
    weekView.collectionViewSource = (NSMutableArray *)self.weekArray;
    weekView.userInteractionEnabled = YES;
    UITapGestureRecognizer *foldGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeFoldStatus)];
    [weekView addGestureRecognizer:foldGesture];
    [self addSubview:(_weekView = weekView)];
    
    //UICollectionView
    MTBaseCollectionView *monthView = [[MTBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, MTScreenSize().width, 500)];
    //    monthView.collectionView.scrollEnabled = NO;
    monthView.cellClassName = @"CalendarMonthCell";
    monthView.dequeCell = ^(UICollectionView *collectionView, NSIndexPath *indexPath){
        CalendarMonthCell *monthCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseId forIndexPath:indexPath];
        monthCell.selectDate = ^(CalendarDay *day){
            [weakSelf monthCellDidSelectDay:day];
        };
        return monthCell;
    };
    monthView.collectionView.pagingEnabled = YES;
    monthView.isFromXib = NO;
    monthView.numofLine = 1;
    monthView.numInaLine = 1;
    monthView.itemWidth = self.viewWidth-2*self.space;
    monthView.itemHeight = LineHeight*6;
    self.lineHeightOfDayCell = LineHeight;
    monthView.scrollerBlock = ^(NSInteger page){
        [weakSelf changeTitleWith:page];
    };
    [monthView startLayout];
    self.monthViewHeight = [monthView getmtBaseHeight];
    [self addSubview:(_monthView = monthView)];
    monthView.collectionViewSource = (NSMutableArray *)self.dataArray;
    //添加监听者
    [monthView.collectionView addObserver:self forKeyPath:@"contentSize" options: NSKeyValueObservingOptionNew context:nil];
    [monthView.collectionView addObserver:self forKeyPath:@"contentOffset" options: NSKeyValueObservingOptionNew context:nil];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(weakSelf.space);
        make.left.equalTo(weakSelf).offset(weakSelf.space);
        make.right.equalTo(weakSelf).offset(-weakSelf.space);
        make.height.mas_equalTo(weakSelf.dateLabelHeight);
    }];
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(dateLabel);
        make.width.mas_equalTo(50);
    }];
    
    [weekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(weakSelf.space);
        make.left.equalTo(weakSelf).offset(weakSelf.space);
        make.right.equalTo(weakSelf).offset(-weakSelf.space);
        make.height.mas_equalTo(weakSelf.weekViewHeight);
    }];
    
    [monthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weekView.mas_bottom).offset(weakSelf.space);
        make.left.right.equalTo(weekView);
        make.height.mas_equalTo(weakSelf.monthViewHeight);
    }];
}

- (void)monthCellDidSelectDay:(CalendarDay *)day{
    if (self.selectDate) {
        self.selectDate(day);
    }
    for (NSInteger index = 0; index < self.dataArray.count; index ++) {
        if (index == self.indexOfCurrentMonth) {
            continue;
        }
        CalendarMonth *month = self.dataArray[index];
        for (CalendarDay *days in month.days) {
            days.isSelect = NO;
        }
    }
    [self.monthView.collectionView reloadData];
}

- (void)changeTitleWith:(NSInteger)page{
    CalendarMonth *model = self.dataArray[page];
    self.indexOfCurrentMonth = page;
    self.dateLabel.text = [NSString stringWithFormat:@"%04d年%02d月", (int)model.year, (int)model.month];
}

- (void)setFoldStatus:(NSInteger)foldStatus{
    _foldStatus = foldStatus;
    if (foldStatus == 1) {
        self.statusLabel.text = @"折叠";
    }else if (foldStatus == 0){
        self.statusLabel.text = @"展开";
    }
    /**
     *  更改所有月的折叠状态
     **/
    for (CalendarMonth *model in self.dataArray) {
        model.isStatusFold = foldStatus;
    }
    [self.monthView.collectionView reloadData];
}

- (void)changeFoldStatus{
    if (self.foldBlock) {
        if (self.foldStatus == 0) {
            self.foldStatus = 1;
        }else if (self.foldStatus == 1){
            self.foldStatus = 0;
        }
        self.foldBlock(self.foldStatus);
    }
}

- (void)displayData{
    //滚动到当前月
    NSIndexPath *displayIndexPath = [NSIndexPath indexPathForRow:self.indexOfCurrentMonth inSection:0];
    [self.monthView.collectionView scrollToItemAtIndexPath:displayIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [self changeTitleWith:self.indexOfCurrentMonth];}

/**
 *  准备数据
 **/
- (NSArray <CalendarMonth *> *)prepareDataForMonthView{
    MTWeakSelf;
    __block NSMutableArray <CalendarMonth *> *dataArray = [NSMutableArray array];
    [[DateCompent sharedInstance] secondOffsetFromNow:0 rezult:^(DateCompentObject *dateObject) {
        weakSelf.currentTime = dateObject;
        NSInteger year = dateObject.year.integerValue;
        NSInteger startYear = year - 2;
        NSInteger endYear = year + 2;
        for (NSInteger year = startYear; year <= endYear; year ++) {
            for (NSInteger month = 1; month < 13; month ++) {
                [dataArray addObject:[self prepareDataForYear:year andMonth:month]];
            }
        }
    }];
    
    //找打当前时间的数据 并进行更改
    for (NSInteger index = 0; index < dataArray.count; index ++) {
        CalendarMonth *model = dataArray[index];
        if (model.year == self.currentTime.year.integerValue) {
            if (model.month == self.currentTime.month.integerValue) {
                self.indexOfCurrentMonth = index;
                NSInteger indexPathOfFirstDay = [self weekDayFor:model.year Month:model.month Day:1] -1;
                NSInteger indexPathCurrentDay = indexPathOfFirstDay + self.currentTime.day.integerValue - 1;
                model.days[indexPathCurrentDay].isNow = YES;
                model.days[indexPathCurrentDay].isSelect = YES;
                NSInteger count = indexPathCurrentDay + 1;
                model.displayLineForFoldStatus = count/7 + (count % 7 > 0 ? 1 : 0) -1;
                break;
            }
        }
    }
    return dataArray;
}

/**
 *  获取一年当中，每个月的天数以及每天的星期几
 **/
- (CalendarMonth *)prepareDataForYear:(NSInteger)year andMonth:(NSInteger)month{
    NSInteger monthTotalDay = [self calculateDayWithMonthAndYear:month year:year];
    CalendarMonth *monthOfYear = [CalendarMonth new];
    monthOfYear.year = year;
    monthOfYear.month = month;
    monthOfYear.totalMonthDay= monthTotalDay;
    NSMutableArray <CalendarDay *> *days = [NSMutableArray array];
    
    NSInteger firstDay2IndexPath = [self weekDayFor:year Month:month Day:1] - 1;
    NSInteger lastDay2IndexPath = firstDay2IndexPath + monthTotalDay - 1;
    
    //上月天数
    NSInteger lastMonth = month-1;
    NSInteger lastMonthInyear = year;
    if (lastMonth <= 0) {
        lastMonth = 12;
        lastMonthInyear = year-1;
    }
    NSInteger lastMonthTotalDay = [self calculateDayWithMonthAndYear:lastMonth year:lastMonthInyear];
    for (NSInteger row = 0; row < firstDay2IndexPath; row ++) {
        CalendarDay *dayOfMonth = [CalendarDay new];
        dayOfMonth.month = month-1;
        dayOfMonth.day = (lastMonthTotalDay - (firstDay2IndexPath - row) + 1);
        dayOfMonth.previouOrCurrentOrNext = -1;
        [days addObject:dayOfMonth];
    }
    //当月天数
    for (NSInteger day = 1; day <= monthTotalDay; day ++) {
        CalendarDay *dayOfMonth = [CalendarDay new];
        dayOfMonth.month = month;
        dayOfMonth.day = day;
        dayOfMonth.year = year;
        dayOfMonth.previouOrCurrentOrNext = 0;
        [days addObject:dayOfMonth];
    }
    
    //下月天数
    NSInteger nextMotnDay = 1;
    NSInteger nextMonth = month+1;
    NSInteger nextYear = year;
    if (nextMonth > 12) {
        nextMonth = 1;
        nextYear++;
    }
    for (NSInteger row = lastDay2IndexPath+1; row < 42; row ++) {
        CalendarDay *dayOfMonth = [CalendarDay new];
        dayOfMonth.month = nextMonth;
        dayOfMonth.day = nextMotnDay++;
        dayOfMonth.year = nextYear;
        dayOfMonth.previouOrCurrentOrNext = 1;
        [days addObject:dayOfMonth];
    }
    monthOfYear.days = days;
    return monthOfYear;
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

/**
 *  计算当月每天星期几
 **/
- (NSInteger)weekDayFor:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day{
    NSString *dayStr = [NSString stringWithFormat:@"%04d-%02d-%02d", (int)year, (int)month, (int)day];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [format dateFromString:dayStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    /**
     *  系统返回的星期是从1开始的
     *  1~7 表示从 星期天到星期六
     **/
    NSInteger weekDay = comps.weekday-1;
    if (weekDay == 0) {//当前是星期天
        weekDay = 7;
    }
    return weekDay;
}

/**
 *  监听属性值发生改变时回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (!self.isSet2Middle) {
            self.isSet2Middle = YES;
            [self displayData];
        }
    }
}

- (void)setMatterArray:(NSArray <CalendarDay *> *)matterArray{
    _matterArray = matterArray;
    //找到年月
    NSInteger year = matterArray[0].year;
    NSInteger month = matterArray[0].month;
    CalendarMonth *matterMonth = nil;
    for (CalendarMonth *model in self.dataArray) {
        if (model.year == year) {
            if (model.month == month) {
                matterMonth = model;
                break;
            }
        }
    }
    for (CalendarDay *matterDay in matterArray) {
        for (CalendarDay *monthDay in matterMonth.days) {
            if (matterDay.day == monthDay.day) {
                monthDay.isHaveMatter = 1;
                break;
            }
        }
    }
    [self.monthView.collectionView reloadData];
}

- (void)dealloc{
    [self.monthView.collectionView removeObserver:self forKeyPath:@"contentSize"];
    [self.monthView.collectionView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
