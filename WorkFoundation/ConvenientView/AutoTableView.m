//
//  AutoTableView.m
//  TestGitHub
//
//  Created by MenThu on 16/7/23.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "AutoTableView.h"
#import "MJRefresh.h"



NSInteger const FirstPageNo = 1;



@interface AutoTableView ()

@property (nonatomic, assign, readwrite) NSInteger  pageNo;

@end


@implementation AutoTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        [self configSetUp];
    }
    return self;
}


- (void)awakeFromNib
{
    [self configSetUp];
}

- (void)configSetUp
{
    self.pageNo = FirstPageNo;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 44.0;
#endif
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


- (void)setDownBlock:(DownRefresh)downBlock
{
    if (downBlock) {
        self.pageNo = FirstPageNo;
        @weakify(self);
        _downBlock = downBlock;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.pageNo = FirstPageNo;
            [self.mj_header endRefreshing];
            downBlock(self.pageNo);
        }];
    }
}

- (void)setUpBlock:(UpRefresh)upBlock
{
    if (upBlock) {
        @weakify(self);
        _upBlock = upBlock;
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.pageNo++;
            [self.mj_footer endRefreshing];
            upBlock(self.pageNo);
        }];
    }
}

@end
