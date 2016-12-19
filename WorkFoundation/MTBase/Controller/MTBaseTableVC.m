//
//  MTBaseTableVC.m
//  rrmjMT
//
//  Created by MenThu on 2016/12/12.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseTableVC.h"

static NSString *cellReusableId = @"cellId";
@interface MTBaseTableVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _requestPageNo;
}

@property (nonatomic, strong, readwrite) UITableView *mtBaseTableView;

@end

@implementation MTBaseTableVC

- (void)configView{
    [self baseInitVaribles];
    [self initVaribles];
    [self initTableView];
}

#pragma mark - 私有方法
- (void)baseInitVaribles{
    self.cellClassName = @"";
    self.isFromXib = YES;
    _requestPageNo = self.requeStartPageNo = 1;
    self.isStylePlain = YES;
    self.baseTableMargin = @[@(0),@(0),@(0),@(0)];
    @weakify(self);
    self.refreshBlock = ^(NSInteger pageNo){
        @strongify(self);
        [self dragTableHttpRequest:pageNo];
    };
}

- (void)initTableView{
    NSAssert([self.cellClassName isExist], @"cellClassName不存在!!!");
    @weakify(self);
    _requestPageNo = self.requeStartPageNo;
    UITableView *mtBaseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(self.isStylePlain ? UITableViewStylePlain : UITableViewStyleGrouped)];
    mtBaseTableView.delegate = self;
    mtBaseTableView.dataSource = self;
    mtBaseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mtBaseTableView.showsVerticalScrollIndicator = mtBaseTableView.showsHorizontalScrollIndicator = NO;
    if (self.isFromXib) {
        [mtBaseTableView registerNib:[UINib nibWithNibName:self.cellClassName bundle:nil] forCellReuseIdentifier:cellReusableId];
    }else{
        [mtBaseTableView registerClass:NSClassFromString(self.cellClassName) forCellReuseIdentifier:cellReusableId];
    }
    if (self.refreshBlock) {
        //有上拉下载刷新
        mtBaseTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            _requestPageNo ++;
            self.refreshBlock(_requestPageNo);
        }];
        
        mtBaseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            _requestPageNo = self.requeStartPageNo;
            self.refreshBlock(_requestPageNo);
        }];
    }
    
    [self.view addSubview:mtBaseTableView];
    CGFloat top = self.baseTableMargin[0].floatValue;
    CGFloat left = self.baseTableMargin[1].floatValue;
    CGFloat bottom = -self.baseTableMargin[2].floatValue;
    CGFloat right = -self.baseTableMargin[3].floatValue;
    [mtBaseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(top);
        make.left.equalTo(self.view).offset(left);
        make.bottom.equalTo(self.view).offset(bottom);
        make.right.equalTo(self.view).offset(right);
    }];
    self.mtBaseTableView = mtBaseTableView;
    self.contentView = mtBaseTableView;
}


#pragma mark - 公开方法
- (void)initVaribles{
    
}

- (void)dragTableHttpRequest:(NSInteger)pageNo{
    
}

- (void)endTableRefresh{
    if (_requestPageNo == self.requeStartPageNo) {
        [self.mtBaseTableView.mj_header endRefreshing];
    }else{
        [self.mtBaseTableView.mj_footer endRefreshing];
    }
}

- (void)setTableSource:(NSArray<MTBaseModel *> *)tableSource{
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
    MTBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusableId forIndexPath:indexPath];
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
