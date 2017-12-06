//
//  MTCollectionView.m
//  MTCollectionView
//
//  Created by MenThu on 2017/12/4.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import "MTCollectionView.h"
#import "MTCollectionViewCell.h"
#import "MTProxy.h"

@interface MTCollectionView ()

@property (nonatomic, strong) MTProxy *dataSourceProxy;
@property (nonatomic, strong) MTProxy *delegateProxy;

@end

@implementation MTCollectionView

#pragma mark - LifeCircle
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self configView];
    }
    return self;
}

#pragma mark - Public
/**
 *  配置视图
 **/
- (void)configView{
    self.collectionSource = @[].mutableCopy;
    self.delegateProxy = [MTProxy alloc];
    self.dataSourceProxy = [MTProxy alloc];
    self.delegateProxy.topRecevier = self;
    self.dataSourceProxy.topRecevier = self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([self.dataSourceProxy.secondRecevier respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        return [self.dataSourceProxy.secondRecevier numberOfSectionsInCollectionView:collectionView];
    }else{
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.dataSourceProxy.secondRecevier respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        return [self.dataSourceProxy.secondRecevier collectionView:collectionView numberOfItemsInSection:section];
    }else{
        return self.collectionSource.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = nil;
    if ([self.dataSourceProxy.secondRecevier respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        cell = [self.dataSourceProxy.secondRecevier collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }else{
        MTCollectionViewCell *mtCell = (MTCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:self.registerCellArray[0].cellClassName forIndexPath:indexPath];
        if ([mtCell isKindOfClass:[MTCollectionViewCell class]]) {
            mtCell.cellModel = self.collectionSource[indexPath.row];
        }
        cell = mtCell;
    }
    return cell;
}

#pragma mark - Setter
- (void)setRegisterCellArray:(NSArray <MTRegisterModel *> *)registerCellArray{
    if ([registerCellArray isKindOfClass:[NSArray class]] && registerCellArray.count > 0) {
        _registerCellArray = registerCellArray;
        for (MTRegisterModel *model in registerCellArray) {
            if (model.isCellFromXib) {
                [self registerNib:[UINib nibWithNibName:model.cellClassName bundle:nil] forCellWithReuseIdentifier:model.cellClassName];
            }else{
                [self registerClass:NSClassFromString(model.cellClassName) forCellWithReuseIdentifier:model.cellClassName];
            }
        }
    }
}

- (void)setCollectionSource:(NSMutableArray *)collectionSource{
    if ([collectionSource isKindOfClass:[NSArray class]]) {
        _collectionSource = [NSMutableArray arrayWithArray:collectionSource];
        [self reloadData];
    }
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate{
    if (delegate != self.delegateProxy) {
        self.delegateProxy.secondRecevier = delegate;
    }
    [super setDelegate:(id<UICollectionViewDelegate>)self.delegateProxy];
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource{
    if (dataSource != self.dataSourceProxy) {
        self.dataSourceProxy.secondRecevier = dataSource;
    }
    [super setDataSource:(id<UICollectionViewDataSource>)self.dataSourceProxy];
}

@end
