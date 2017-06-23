//
//  CalendarMonthCell.m
//  artapp
//
//  Created by MenThu on 17/6/20.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "CalendarMonthCell.h"
#import "CalendarMonth.h"

@interface CalendarMonthCell ()
@property (nonatomic, weak) MTBaseCollectionView *dayView;
@property (nonatomic, assign) BOOL isFirstShow;
@end

@implementation CalendarMonthCell

- (void)customView{
    MTWeakSelf;
    MTBaseCollectionView *dayView = [[MTBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, MTScreenSize().width, 500)];
    dayView.numInaLine = 7;
    dayView.numofLine = 6;
    dayView.itemHeight = LineHeight;
    dayView.cellClassName = @"CalendarDayCell";
    dayView.isFromXib = NO;
    dayView.isScrollDirectionHorizon = NO;
    dayView.selectItem = ^(NSIndexPath *indexPath, UICollectionView *selectView){
        [weakSelf selectDay:indexPath];
    };
    [dayView startLayout];
    [self.contentView addSubview:(_dayView = dayView)];
    [self addKvo];
    self.isFirstShow = YES;
    
    [dayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
}

- (void)updateCustomView{
    CalendarMonth *month = (CalendarMonth *)self.cellModel;
    self.dayView.collectionViewSource = (NSMutableArray *)month.days;
    [self setFoldStatus:month.isStatusFold];
}

- (void)selectDay:(NSIndexPath *)indexPath{
    CalendarMonth *month = (CalendarMonth *)self.cellModel;
    CalendarDay *selectItem = month.days[indexPath.row];
    if (selectItem.previouOrCurrentOrNext!=0 || selectItem.isSelect) {
        return;
    }else{
        for (CalendarDay *model in month.days) {
            model.isSelect = NO;
        }
        selectItem.isSelect = YES;
        self.dayView.collectionViewSource = (NSMutableArray *)month.days;
        NSInteger count = indexPath.row + 1;
        month.displayLineForFoldStatus = count / 7 + (count % 7 > 0 ? 1 : 0) - 1;
        if (self.selectDate) {
            self.selectDate(selectItem);
        }
    }
}

- (void)setFoldStatus:(NSInteger)isFold{
    CalendarMonth *month = (CalendarMonth *)self.cellModel;
    if (isFold == 1) {
        //展开
        self.dayView.collectionView.contentOffset = CGPointZero;
    }else{
        self.dayView.collectionView.contentOffset = CGPointMake(0, month.displayLineForFoldStatus*LineHeight);
    }
}

- (void)addKvo{
    [self.dayView.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeKvo{
    [self.dayView.collectionView removeObserver:self forKeyPath:@"contentSize"];
}

/**
 *  监听属性值发生改变时回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (self.isFirstShow == NO) {
            return;
        }
        self.isFirstShow = NO;
        CalendarMonth *model = (CalendarMonth *)self.cellModel;
        if (model.isStatusFold == 1) {
            return;
        }
        BOOL isNow = NO;
        for (CalendarDay *dayOfMonth in model.days) {
            if (dayOfMonth.isNow == YES) {
                isNow = YES;
                break;
            }
        }
        if (isNow) {
            self.dayView.collectionView.contentOffset = CGPointMake(0, model.displayLineForFoldStatus*LineHeight);
        }
    }
}
- (void)dealloc{
    [self removeKvo];
}

@end
