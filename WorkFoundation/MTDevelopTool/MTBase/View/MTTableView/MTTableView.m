//
//  MTTableView.m
//  MTCollectionView
//
//  Created by MenThu on 2017/12/6.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import "MTTableView.h"
#import "MTProxy.h"
#import "MTTableViewCell.h"

@interface MTTableView ()

@property (nonatomic, strong) MTProxy *dataSourceProxy;
@property (nonatomic, strong) MTProxy *delegateProxy;

@end

@implementation MTTableView

#pragma mark - LifeCircle
- (void)awakeFromNib{
    [super awakeFromNib];
    [self configView];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self configView];
    }
    return self;
}

#pragma mark - Public
- (void)configView{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSourceProxy = [[MTProxy alloc] init];
    self.dataSourceProxy.topRecevier = self;
    self.delegateProxy = [[MTProxy alloc] init];
    self.delegateProxy.topRecevier = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.dataSourceProxy.secondRecevier respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.dataSourceProxy.secondRecevier numberOfSectionsInTableView:tableView];
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.dataSourceProxy.secondRecevier respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [self.dataSourceProxy.secondRecevier tableView:tableView numberOfRowsInSection:section];
    }else{
        return self.tableViewSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSourceProxy.secondRecevier respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        return [self.dataSourceProxy.secondRecevier tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        MTTableViewCell *mtTableCell = [tableView dequeueReusableCellWithIdentifier:self.registerCellArray[0].cellClassName forIndexPath:indexPath];
#if DEBUG
        NSAssert([mtTableCell isKindOfClass:[MTTableViewCell class]], @"");
#endif
        mtTableCell.cellModel = self.tableViewSource[indexPath.row];
        return mtTableCell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:indexPath];
    if ([self.delegateProxy.secondRecevier respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegateProxy.secondRecevier tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegateProxy.secondRecevier respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.delegateProxy.secondRecevier tableView:tableView heightForRowAtIndexPath:indexPath];
    }else{
        return self.tableViewSource[indexPath.row].cellHeight;
    }
}

#pragma mark - Setter
- (void)setRegisterCellArray:(NSArray<MTRegisterModel *> *)registerCellArray{
    if ([registerCellArray isKindOfClass:[NSArray class]] && registerCellArray.count > 0) {
        for (MTRegisterModel *model in registerCellArray) {
            if (model.isCellFromXib) {
                [self registerNib:[UINib nibWithNibName:model.cellClassName bundle:nil] forCellReuseIdentifier:model.cellClassName];
            }else{
                [self registerClass:NSClassFromString(model.cellClassName) forCellReuseIdentifier:model.cellClassName];
            }
        }
        _registerCellArray = registerCellArray;
    }
}

- (void)setTableViewSource:(NSMutableArray<MTTableViewCellModel *> *)tableViewSource{
    if ([tableViewSource isKindOfClass:[NSArray class]]) {
        _tableViewSource = [NSMutableArray arrayWithArray:tableViewSource];
        [self reloadData];
    }
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate{
    if (delegate != self && delegate != self.delegateProxy) {
        self.delegateProxy.secondRecevier = delegate;
    }
    [super setDelegate:(id<UITableViewDelegate>)self.delegateProxy];
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource{
    if (dataSource != self && dataSource != self.dataSourceProxy) {
        self.dataSourceProxy.secondRecevier = dataSource;
    }
    [super setDataSource:(id<UITableViewDataSource>)self.dataSourceProxy];
}

@end
