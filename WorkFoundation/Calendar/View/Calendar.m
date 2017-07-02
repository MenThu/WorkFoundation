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
 *  展开收起状态btn
 **/
@property (nonatomic, weak) UIButton *statusBtn;

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
 *  当前展示的月在数组中的下表
 **/
@property (nonatomic, assign) NSInteger indexOfCurrentMonth;

@property (nonatomic, assign) NSInteger nowTimeIndexInDataArray;

@end

@implementation Calendar

- (instancetype)initWithWidth:(CGFloat)viewWidth{
    MTWeakSelf;
    if (self = [super init]) {
        self.viewWidth = viewWidth;
        [self prepareData];
        [self getMonthCourse:self.indexOfCurrentMonth finish:^{
            [weakSelf configView];
        }];
        [self registerNotification];
    }
    return self;
}

//
- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(go2Today) name:kCalendarGo2Today object:nil];
}

- (void)go2Today{
    CalendarMonth *nowMonth = self.dataArray[self.nowTimeIndexInDataArray];
    NSInteger line = 0;
    for (NSInteger index = 0; index < nowMonth.days.count; index ++) {
        CalendarDay *day = nowMonth.days[index];
        if (day.isNow) {
            day.isSelect = YES;
            line = (index+1)/7 + ((index+1) % 7 > 0 ? 1 : 0) - 1;
        }else{
            day.isSelect = NO;
        }
    }
    
    for (NSInteger index = 0; index < self.nowTimeIndexInDataArray; index ++) {
        CalendarMonth *month = self.dataArray[index];
        for (CalendarDay *day in month.days) {
            day.isSelect = NO;
        }
    }
    for (NSInteger index = self.nowTimeIndexInDataArray+1; index < self.dataArray.count; index ++) {
        CalendarMonth *month = self.dataArray[index];
        for (CalendarDay *day in month.days) {
            day.isSelect = NO;
        }
    }
    [self.monthView.collectionView reloadData];
    
    //滚动到今天
    CGFloat newOffsetX = self.nowTimeIndexInDataArray * self.viewWidth;
    CGFloat newOffsetY = line*LineHeight;
    if (self.foldStatus == 1) {
        newOffsetY = 0;
    }
    CGPoint offset = CGPointMake(newOffsetX, newOffsetY);
    [self.monthView.collectionView setContentOffset:offset animated:YES];
}

- (void)prepareData{
    _foldStatus = 0;
    self.indexOfCurrentMonth = -1;
    self.isSet2Middle = NO;
    self.lineForFoldStatus = 1;
    self.weekArray = @[@(1), @(2), @(3), @(4), @(5), @(6), @(7)];
    self.space = 10.f;
    self.nowTimeIndexInDataArray = -1;
    self.dateLabelHeight = 45.f;
    self.dataArray = [self prepareDataForMonthView];
}

- (CGFloat)getHeight:(BOOL)isFold{
    NSInteger line = (isFold == YES ? self.lineForFoldStatus: 6);
    CGFloat height = self.dateLabelHeight + self.weekViewHeight + LineHeight*line;
    return height;
}

- (void)configView{
    MTWeakSelf;
    self.backgroundColor = mtColor;
    self.clipsToBounds = YES;
    
    //title
    UILabel *dateLabel = [UILabel new];
    dateLabel.userInteractionEnabled = YES;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [UIFont systemFontOfSize:13];
    dateLabel.textColor = [UIColor darkTextColor];
    CalendarMonth *model = self.dataArray[self.indexOfCurrentMonth];
    dateLabel.text = [NSString stringWithFormat:@"%04d年%02d月", (int)model.year, (int)model.month];
    dateLabel.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *foldOrUnfoldAct = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeFoldStatus)];
    [dateLabel addGestureRecognizer:foldOrUnfoldAct];
    [self addSubview:(_dateLabel = dateLabel)];
    
    //展开(收起)
    UIButton *statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    statusBtn.userInteractionEnabled = NO;
    [statusBtn setTitle:@"展开" forState:UIControlStateNormal];
    [statusBtn setTitle:@"收起" forState:UIControlStateSelected];
    [statusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    statusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:(_statusBtn = statusBtn)];
    
    //星期
    MTBaseCollectionView *weekView = [[MTBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, MTScreenSize().width, 500)];
    weekView.cellClassName = @"CalendarWeekCell";
    weekView.isFromXib = NO;
    weekView.numofLine = 1;
    weekView.itemWidth = (self.viewWidth) / self.weekArray.count;
    weekView.itemHeight = 30.f;
    weekView.backgroundColor = [UIColor whiteColor];
    [weekView startLayout];
    self.weekViewHeight = [weekView getmtBaseHeight];
    weekView.collectionViewSource = (NSMutableArray *)self.weekArray;
    weekView.userInteractionEnabled = YES;
    UITapGestureRecognizer *foldGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeFoldStatus)];
    [weekView addGestureRecognizer:foldGesture];
    [self addSubview:(_weekView = weekView)];
    
    //UICollectionView
    MTBaseCollectionView *monthView = [[MTBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, MTScreenSize().width, 500)];
    monthView.cellClassName = @"CalendarMonthCell";
    monthView.dequeCell = ^(UICollectionView *collectionView, NSIndexPath *indexPath){
        CalendarMonthCell *monthCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseId forIndexPath:indexPath];
        monthCell.selectDate = ^(CalendarDay *day){
            [weakSelf monthCellDidSelectDay:day];
        };
        return monthCell;
    };
    monthView.collectionView.pagingEnabled = YES;
    //默认状态是折叠，而折叠状态下，日历表不允许滚动
    monthView.collectionView.scrollEnabled = NO;
    monthView.isFromXib = NO;
    monthView.numofLine = 1;
    monthView.numInaLine = 1;
    monthView.itemWidth = self.viewWidth;
    monthView.itemHeight = LineHeight*6;
    monthView.scrollerBlock = ^(NSInteger page){
        [weakSelf changeTitleWith:page];
    };
    monthView.backgroundColor = [UIColor whiteColor];
    [monthView startLayout];
    self.monthViewHeight = [monthView getmtBaseHeight];
    [self addSubview:(_monthView = monthView)];
    monthView.collectionViewSource = (NSMutableArray *)self.dataArray;
    //添加监听者
    [monthView.collectionView addObserver:self forKeyPath:@"contentSize" options: NSKeyValueObservingOptionNew context:nil];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(weakSelf.dateLabelHeight);
    }];
    
    [statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(dateLabel);
        make.right.equalTo(dateLabel).offset(-5);
        make.width.mas_equalTo(80);
    }];
    
    [weekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(weakSelf.weekViewHeight);
    }];
    
    [monthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weekView.mas_bottom);
        make.left.right.equalTo(weekView);
        make.height.mas_equalTo(LineHeight * 6);
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
    if (_indexOfCurrentMonth == page) {
        return;
    }
    CalendarMonth *model = self.dataArray[page];
    self.indexOfCurrentMonth = page;
    self.dateLabel.text = [NSString stringWithFormat:@"%04d年%02d月", (int)model.year, (int)model.month];
    
    if (!model.isSetMonthCourse) {
        model.isSetMonthCourse = YES;
        [self getMonthCourse:page finish:nil];
    }
}

- (void)setFoldStatus:(NSInteger)foldStatus{
    _foldStatus = foldStatus;
    CGFloat oldOffsetX = self.monthView.collectionView.contentOffset.x;
    if (foldStatus == 1) {
        self.statusBtn.selected = YES;
        self.monthView.collectionView.contentOffset = CGPointMake(oldOffsetX, 0);
        self.monthView.collectionView.scrollEnabled = YES;
    }else if (foldStatus == 0){
        self.statusBtn.selected = NO;
        self.monthView.collectionView.scrollEnabled = NO;
        NSInteger selectLine = self.dataArray[self.indexOfCurrentMonth].selectLine;
        self.monthView.collectionView.contentOffset = CGPointMake(oldOffsetX, LineHeight*selectLine);
    }
}

- (void)changeFoldStatus{
    if (self.foldStatus == 1) {
        //将要折叠
        self.foldStatus = 0;
    }else{
        //将要展开
        self.foldStatus = 1;
    }
    if (self.foldBlock) {
        self.foldBlock(self.foldStatus);
    }
}

- (void)displayData{
    if (self.isSet2Middle == YES) {
        return;
    }
    CGSize contentSize = CGSizeMake(self.viewWidth * self.dataArray.count, LineHeight * 6);
    if (!CGSizeEqualToSize(contentSize, self.monthView.collectionView.contentSize)) {
        return;
    }
    self.isSet2Middle = YES;
    //滚动到当前月
    CGFloat offsetY = 0;
    if (self.foldStatus == 0) {
        offsetY = self.dataArray[self.indexOfCurrentMonth].selectLine * LineHeight;
    }
    CGPoint newOffset = CGPointMake(self.indexOfCurrentMonth * self.viewWidth, offsetY);
    self.monthView.collectionView.contentOffset = newOffset;
    [self changeTitleWith:self.indexOfCurrentMonth];
}

/**
 *  准备数据
 **/
- (NSArray <CalendarMonth *> *)prepareDataForMonthView{
    MTWeakSelf;
    __block NSMutableArray <CalendarMonth *> *dataArray = [NSMutableArray array];
    [[DateCompent sharedInstance] secondOffsetFromNow:24*60*60 rezult:^(DateCompentObject *dateObject) {
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
                model.isSetMonthCourse = YES;
                NSInteger indexPathOfFirstDay = [self weekDayFor:model.year Month:model.month Day:1] -1;
                NSInteger indexPathCurrentDay = indexPathOfFirstDay + self.currentTime.day.integerValue - 1;
                model.days[indexPathCurrentDay].isNow = YES;
                model.days[indexPathCurrentDay].isSelect = YES;
                NSInteger count = indexPathCurrentDay + 1;
                model.selectLine = count/7 + (count%7 > 0 ? 1 : 0) - 1;
                break;
            }
        }
    }
    self.nowTimeIndexInDataArray = self.indexOfCurrentMonth;
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
        [self displayData];
    }
}

- (void)setCourseForMonth:(CalendarMonth *)courseForMonth{
    CalendarMonth *currentMonth = nil;
    for (CalendarMonth *model in self.dataArray) {
        if (model.year == courseForMonth.year) {
            if (model.month == courseForMonth.month) {
                currentMonth = model;
                break;
            }
        }
    }
    if (!currentMonth) {
        return;
    }
    for (CalendarDay *day in courseForMonth.days) {
        for (CalendarDay *dayInCurrentMonth in currentMonth.days) {
            if (dayInCurrentMonth.day == day.day && dayInCurrentMonth.previouOrCurrentOrNext == 0) {
                dayInCurrentMonth.isHaveMatter = YES;
                break;
            }
        }
    }
    [self.monthView.collectionView reloadData];
}

/**
 *  请求月行程
 **/
- (void)getMonthCourse:(NSInteger)monthIndex finish:(void (^)(void))finishBlock{
    CalendarMonth *month = self.dataArray[monthIndex];
    NSString *dayStr = [NSString stringWithFormat:@"%04d-%02d", (int)month.year, (int)month.month];
    MTWeakSelf;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"month"] = dayStr;
    HttpRequest *request = [HttpRequest requestWithPath:@"course/getMonthCourse"];
    request.params = params;
    [[HttpClient sharedInstance] post:request blockView:nil finish:^(HttpResponse *response) {
        if (response.success) {
            NSArray <NSNumber *> *dayArray = response.body[@"monthCourses"];
            if ([dayArray isExist]) {
                for (NSNumber *dayValue in dayArray) {
                    for (CalendarDay *monthDay in month.days) {
                        if (monthDay.previouOrCurrentOrNext != 0) {
                            continue;
                        }
                        if (monthDay.day == dayValue.integerValue) {
                            monthDay.isHaveMatter = 1;
                            break;
                        }
                    }
                }
                if (finishBlock) {
                    finishBlock();
                }else{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:monthIndex inSection:0];
                    [weakSelf.monthView.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }
            }
        }
    }];
}

- (void)dealloc{
    [self.monthView.collectionView removeObserver:self forKeyPath:@"contentSize"];
}

@end
