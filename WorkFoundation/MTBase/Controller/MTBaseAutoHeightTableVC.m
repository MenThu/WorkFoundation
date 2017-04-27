//
//  MTBaseAutoHeightTableVC.m
//  artapp
//
//  Created by MenThu on 2017/3/30.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "MTBaseAutoHeightTableVC.h"

static NSString *cellReusableId = @"cellId";
@interface MTBaseAutoHeightTableVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger requestPageNo;

@property (nonatomic, strong, readwrite) UITableView *mtBaseTableView;

@end

@implementation MTBaseAutoHeightTableVC

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
    self.loadMore = ^(NSInteger pageNo){
        [weakSelf dragTableHttpRequest:pageNo];
    };
    
    
    UITableView *mtBaseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(self.isStylePlain ? UITableViewStylePlain : UITableViewStyleGrouped)];
    mtBaseTableView.backgroundColor = [UIColor clearColor];
    mtBaseTableView.rowHeight = UITableViewAutomaticDimension;
    mtBaseTableView.estimatedRowHeight = 100.f;
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
    weakSelf.requestPageNo = self.requeStartPageNo;
    if ([self.cellClassName isExist]) {
        if (self.isFromXib) {
            [self.mtBaseTableView registerNib:[UINib nibWithNibName:self.cellClassName bundle:nil] forCellReuseIdentifier:cellReusableId];
        }else{
            [self.mtBaseTableView registerClass:NSClassFromString(self.cellClassName) forCellReuseIdentifier:cellReusableId];
        }
    }
    if (self.refreshBlock) {
        //有上拉下载刷新
        [self.mtBaseTableView addLegendHeaderWithRefreshingBlock:^{
            weakSelf.requestPageNo = weakSelf.requeStartPageNo;
            weakSelf.refreshBlock(weakSelf.requestPageNo);
        }];
    }
    
    if (self.loadMore) {
        [self.mtBaseTableView addLegendFooterWithRefreshingBlock:^{
            weakSelf.requestPageNo ++;
            weakSelf.loadMore(weakSelf.requestPageNo);
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
    if (_requestPageNo == self.requeStartPageNo) {
        [self.mtBaseTableView.header endRefreshing];
    }else{
        [self.mtBaseTableView.footer endRefreshing];
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
    MTBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusableId forIndexPath:indexPath];
    NSAssert([cell isKindOfClass:[MTBaseCell class]], @"cell必须为cell的子类");
    cell.cellModel = self.tableSource[indexPath.row];
    return cell;
}

- (CGFloat)heightFor:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    return self.tableSource[indexPath.row].cellHeight;
}

- (UIView *)viewForSectionHead:(NSInteger)section{
    return nil;
}

- (CGFloat)heightForSecionHead:(NSInteger)section{
    return 0.01f;
}

- (void)scrollViewMove:(CGPoint)contentOffset view:(UITableView *)tableView{
    
}

- (void)selectIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)displayCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self viewForSectionHead:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.mtBaseTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self displayCell:cell indexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self scrollViewMove:scrollView.contentOffset view:self.mtBaseTableView];
}

@end
