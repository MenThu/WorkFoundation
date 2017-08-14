//
//  MTBaseTableVC.m
//  rrmjMT
//
//  Created by MenThu on 2016/12/12.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseTableVC.h"
NSString *const mtBaseTableControllerCell = @"mtBaseTableControllerCell";

@interface MTBaseTableVC ()<UITableViewDelegate,UITableViewDataSource>

//tableView
@property (nonatomic, strong, readwrite) UITableView *mtBaseTableView;
//当前请求的页数
@property (nonatomic, assign) NSInteger requestPageNo;

@end

@implementation MTBaseTableVC

- (void)configView{
    [self baseInitVaribles];
    [self initVaribles];
    [self initTableView];
}

#pragma mark - 私有方法
- (void)baseInitVaribles{
    MTWeakSelf;
    self.cellClassName = @"";
    self.isFromXib = YES;
    _requestPageNo = self.requeStartPageNo = 1;
    self.isStylePlain = YES;
    self.baseTableMargin = @[@(0),@(0),@(0),@(0)];
    self.refreshBlock = ^(NSInteger pageNo){
        [weakSelf dragTableHttpRequest:pageNo];
    };
    
    UITableView *mtBaseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(self.isStylePlain ? UITableViewStylePlain : UITableViewStyleGrouped)];
    mtBaseTableView.delegate = self;
    mtBaseTableView.dataSource = self;
    mtBaseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mtBaseTableView.showsVerticalScrollIndicator = mtBaseTableView.showsHorizontalScrollIndicator = NO;
    self.mtBaseTableView = mtBaseTableView;
    self.contentView = mtBaseTableView;
    [self.view addSubview:self.mtBaseTableView];
}

- (void)initTableView{
    MTWeakSelf;
    _requestPageNo = self.requeStartPageNo;
    if ([self.cellClassName isExist]) {
        if (self.isFromXib) {
            [self.mtBaseTableView registerNib:[UINib nibWithNibName:self.cellClassName bundle:nil] forCellReuseIdentifier:mtBaseTableControllerCell];
        }else{
            [self.mtBaseTableView registerClass:NSClassFromString(self.cellClassName) forCellReuseIdentifier:mtBaseTableControllerCell];
        }
    }
    if (self.refreshBlock) {
        //有上拉下载刷新
        self.mtBaseTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.requestPageNo++;
            weakSelf.loadMore(weakSelf.requestPageNo);
        }];
        
        self.mtBaseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.requestPageNo = weakSelf.requeStartPageNo;
            weakSelf.refreshBlock(weakSelf.requestPageNo);
        }];
    }
    
    CGFloat top = self.baseTableMargin[0].floatValue;
    CGFloat left = self.baseTableMargin[1].floatValue;
    CGFloat bottom = -self.baseTableMargin[2].floatValue;
    CGFloat right = -self.baseTableMargin[3].floatValue;
    [self.mtBaseTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(top);
        make.left.equalTo(weakSelf.view).offset(left);
        make.bottom.equalTo(weakSelf.view).offset(bottom);
        make.right.equalTo(weakSelf.view).offset(right);
    }];
}


#pragma mark - 公开方法
- (void)initVaribles{
    
}

- (void)dragTableHttpRequest:(NSInteger)pageNo{
    
}

- (void)endTableRefresh{
    if (self.requestPageNo == self.requeStartPageNo) {
        [self.mtBaseTableView.mj_header endRefreshing];
    }else{
        [self.mtBaseTableView.mj_footer endRefreshing];
    }
}

- (void)setTableSource:(NSArray <MTBaseCellModel *> *)tableSource{
    _tableSource = tableSource;
    [self.mtBaseTableView reloadData];
}

- (NSInteger)sectionCountFor:(UITableView *)mtBaseTableview{
    return 1;
}

- (NSInteger)rowCountFor:(NSInteger)section mtBaseTable:(UITableView *)tableView{
    return self.tableSource.count;
}

- (MTBaseCell *)cellForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    MTBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:mtBaseTableControllerCell forIndexPath:indexPath];
    NSAssert([cell isKindOfClass:[MTBaseCell class]], @"cell必须为cell的子类");
    cell.cellModel = self.tableSource[indexPath.row];
    return cell;
}

- (CGFloat)heightFor:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    return self.tableSource[indexPath.row].cellHeight;
}

- (void)scrollViewMove:(CGPoint)contentOffset view:(UITableView *)tableView{
    
}

#pragma mark - UITableView的代理及数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self sectionCountFor:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self rowCountFor:section mtBaseTable:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellForIndexPath:indexPath tableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self heightFor:indexPath tableView:tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self scrollViewMove:scrollView.contentOffset view:self.mtBaseTableView];
}


@end
