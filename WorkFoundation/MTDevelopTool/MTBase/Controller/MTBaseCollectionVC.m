//
//  MTBaseCollectionVC.m
//  rrmjMT
//
//  Created by MenThu on 2016/12/12.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseCollectionVC.h"
#import "MTBaseCollectionCell.h"

NSString *const mtBaseCollectionControllerCell = @"mtBaseCollectionControllerCell";

@interface MTBaseCollectionVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong, readwrite) UICollectionView *collectionView;

@end

@implementation MTBaseCollectionVC

- (void)configView{
    [self defaultVariableValue];
    [self initVariable];
    [self initCollectionView];
}

#pragma mark - 内部方法
//默认值初始化
- (void)defaultVariableValue{
    self.cellClassName = @"";
    self.isFromXib = YES;
    self.collectionViewMarginArray = @[@(0),@(0),@(0),@(0)];
    self.itemWidth = 50.f;
    self.itemHeight = 50.f;
    self.horizonSpace = 0.f;
    self.verticalSpace = 0.f;
    self.isScrollDirectionHorizon = YES;
}

- (void)initCollectionView{
    MTWeakSelf;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    //判断滚动方向
    if (self.isScrollDirectionHorizon) {
        layout.minimumLineSpacing = self.horizonSpace;
        layout.minimumInteritemSpacing = self.verticalSpace;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }else{
        //设置item行与行之间的间隙
        layout.minimumLineSpacing = self.verticalSpace;
        //设置item列与列之间的间隙
        layout.minimumInteritemSpacing = self.horizonSpace;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    layout.itemSize = CGSizeMake(self.itemWidth, self.itemHeight);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    if ([self.cellClassName isExist]) {
        if (self.isFromXib) {
            [collectionView registerNib:[UINib nibWithNibName:self.cellClassName bundle:nil] forCellWithReuseIdentifier:mtBaseCollectionControllerCell];
        }else{
            [collectionView registerClass:NSClassFromString(self.cellClassName) forCellWithReuseIdentifier:mtBaseCollectionControllerCell];
        }
    }
    [self.view addSubview:collectionView];
    CGFloat top = self.collectionViewMarginArray[0].floatValue;
    CGFloat left = self.collectionViewMarginArray[1].floatValue;
    CGFloat bottom = -self.collectionViewMarginArray[2].floatValue;
    CGFloat right = -self.collectionViewMarginArray[3].floatValue;
    [collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(top);
        make.left.equalTo(weakSelf.view).offset(left);
        make.bottom.equalTo(weakSelf.view).offset(bottom);
        make.right.equalTo(weakSelf.view).offset(right);
    }];
    self.collectionView = collectionView;
}


#pragma mark - 公开方法
- (void)initVariable{
    
}

- (void)setCollectionViewSource:(NSArray *)collectionViewSource{
    _collectionViewSource = collectionViewSource;
    [self.collectionView reloadData];
}

- (void)scrollViewMove:(CGPoint)contentOffset view:(UICollectionView *)scrollView{
    
}

- (MTBaseCollectionCell *)cellForIndexPath:(NSIndexPath *)indexPath view:(UICollectionView *)collectionView{
    MTBaseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mtBaseCollectionControllerCell forIndexPath:indexPath];
    return cell;
}

- (void)selectIndexPath:(NSIndexPath *)indexPath view:(UICollectionView *)collectionView{
    
}

#pragma mark - UICollectinView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionViewSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MTBaseCollectionCell *cell = [self cellForIndexPath:indexPath view:collectionView];
    NSAssert([cell isKindOfClass:[MTBaseCollectionCell class]], @"cell必须是MTBaseCollectionCell的子类");
    cell.cellModel = self.collectionViewSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self selectIndexPath:indexPath view:collectionView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self scrollViewMove:scrollView.contentOffset view:self.collectionView];
}

@end
