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
    self.isFirstShow = YES;
    
    [dayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
}

- (void)updateCustomView{
    CalendarMonth *month = (CalendarMonth *)self.cellModel;
    self.dayView.collectionViewSource = (NSMutableArray *)month.days;
}

- (void)selectDay:(NSIndexPath *)indexPath{
    CalendarMonth *month = (CalendarMonth *)self.cellModel;
    CalendarDay *selectItem = month.days[indexPath.row];
    if (selectItem.previouOrCurrentOrNext!= 0 || selectItem.isSelect) {
        return;
    }else{
        MyLog(@"indexPath:[%d:%d]", (int)indexPath.section, (int)indexPath.row);
        //计算点击的日期
        NSInteger count = indexPath.row + 1;
        month.selectLine = count / 7 + (count % 7 > 0 ? 1 : 0) - 1;
        
        //重载日历表
        for (CalendarDay *model in month.days) {
            model.isSelect = NO;
        }
        selectItem.isSelect = YES;
        self.dayView.collectionViewSource = (NSMutableArray *)month.days;
        
        //回调
        if (self.selectDate) {
            self.selectDate(selectItem);
        }
    }
}

@end
