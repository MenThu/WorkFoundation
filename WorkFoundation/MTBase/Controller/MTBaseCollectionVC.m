//
//  MTBaseCollectionVC.m
//  rrmjMT
//
//  Created by MenThu on 2016/12/12.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseCollectionVC.h"
#import "MTBaseCollectionCell.h"

static NSString *collectionCellReuseId = @"cellId";

@interface MTBaseCollectionVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGFloat _itemWidth;
}

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong, readwrite) UICollectionView *collectionView;

@end

@implementation MTBaseCollectionVC

- (void)configView{
    [self defaultVariableValue];
    [self initVariable];
    [self calculateItemWidth];
    [self initCollectionView];
}

#pragma mark - 内部方法
//默认值初始化
- (void)defaultVariableValue{
    self.cellClassName = @"";
    self.isFromXib = YES;
    self.collectionViewMarginArray = @[@(0),@(0),@(0),@(0)];
    self.numInaLine = 1;
    self.itemHeight = 50.f;
    self.horizonSpace = 0.f;
    self.verticalSpace = 0.f;
    self.isScrollDirectionHorizon = YES;
}

- (void)calculateItemWidth{
    //因为UICollectionView是在控制器中，所以当制定了 collectionViewMarginArray , horizonSpace 和 numInaLine 之后，可以计算出_itemWidth
    CGFloat left = self.collectionViewMarginArray[1].floatValue;
    CGFloat right = self.collectionViewMarginArray[3].floatValue;
    _itemWidth = (YYScreenSize().width - left - right - ceilf(self.numInaLine) * self.horizonSpace) / self.numInaLine;
}

- (void)initCollectionView{
    NSAssert([self.cellClassName isExist], @"cellClassName不能为空!!!");
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    // 设置item行与行之间的间隙
    layout.minimumLineSpacing = self.verticalSpace;
    // 设置item列与列之间的间隙
    layout.minimumInteritemSpacing = self.horizonSpace;
    //滚动方向
    layout.scrollDirection = (self.isScrollDirectionHorizon ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical);
    layout.itemSize = CGSizeMake(_itemWidth, self.itemHeight);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    if (self.isFromXib) {
        [collectionView registerNib:[UINib nibWithNibName:self.cellClassName bundle:nil] forCellWithReuseIdentifier:collectionCellReuseId];
    }else{
        [collectionView registerClass:NSClassFromString(self.cellClassName) forCellWithReuseIdentifier:collectionCellReuseId];
    }
    [self.view addSubview:collectionView];
    CGFloat top = self.collectionViewMarginArray[0].floatValue;
    CGFloat left = self.collectionViewMarginArray[1].floatValue;
    CGFloat bottom = -self.collectionViewMarginArray[2].floatValue;
    CGFloat right = -self.collectionViewMarginArray[3].floatValue;
    @weakify(self);
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(top);
        make.left.equalTo(self.view).offset(left);
        make.bottom.equalTo(self.view).offset(bottom);
        make.right.equalTo(self.view).offset(right);
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

#pragma mark - UICollectinView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionViewSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MTBaseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellReuseId forIndexPath:indexPath];
    NSAssert([cell isKindOfClass:[MTBaseCollectionCell class]], @"cell必须是MTBaseCollectionCell的子类");
    cell.cellModel = self.collectionViewSource[indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self scrollViewMove:scrollView.contentOffset view:self.collectionView];
}

@end
