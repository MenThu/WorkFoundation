//
//  MTBaseCollectionView.m
//  rrmjMT
//
//  Created by MenThu on 2016/12/10.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseCollectionView.h"
#import "MTBaseCollectionCell.h"
NSString *const mtBaseCollectionViewCell = @"mtBaseCollectionViewCell";

@interface MTBaseCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGFloat _viewHeight;
}

@end

@implementation MTBaseCollectionView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self configMtBaseView];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configMtBaseView];
    }
    return self;
}

- (void)configMtBaseView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.userInteractionEnabled = YES;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    self.numInaLine = 1;
    self.horizonSpace = self.verticalSpace = 0;
    self.numofLine = 1;
    self.isFromXib = YES;
    self.isScrollDirectionHorizon = YES;
    self.itemWidth = 0.f;
    self.itemHeight = 50.f;
    self.marginArray = @[@(0),@(0),@(0),@(0)];
    self.sectionInset = UIEdgeInsetsZero;
    [self initVariable];
    [self customView];
    [self startLayout];
}

- (void)initVariable{
    
}

- (void)customView{
    
}

- (CGFloat)calculateBaseHeight{
    //显示的行数 * itemHeight + (显示的行数 - 1) * verticalSpace + 上下的间距
     return (self.numofLine * self.itemHeight + (self.numofLine - 1) * self.verticalSpace + self.marginArray[0].floatValue + self.marginArray[2].floatValue);
}

//告诉MTBaseCollectionView上述变量开始布局
- (void)startLayout{
    //初始化layout
    UICollectionView *collectionView = self.collectionView;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    layout.sectionInset = self.sectionInset;
    //滚动方向
    layout.scrollDirection = (self.isScrollDirectionHorizon ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical);
    if (self.isScrollDirectionHorizon) {
        layout.minimumLineSpacing = self.horizonSpace;
        layout.minimumInteritemSpacing = self.verticalSpace;
    }else{
        // 设置item行与行之间的间隙
        layout.minimumLineSpacing = self.verticalSpace;
        // 设置item列与列之间的间隙
        layout.minimumInteritemSpacing = self.horizonSpace;
    }
        
    if ([self.cellClassName isExist]) {
        if (self.isFromXib) {
            [collectionView registerNib:[UINib nibWithNibName:self.cellClassName bundle:nil] forCellWithReuseIdentifier:mtBaseCollectionViewCell];
        }else{
            [collectionView registerClass:NSClassFromString(self.cellClassName) forCellWithReuseIdentifier:mtBaseCollectionViewCell];
        }
    }
    
    CGFloat top = self.marginArray[0].floatValue;
    CGFloat left = self.marginArray[1].floatValue;
    CGFloat bottom = -self.marginArray[2].floatValue;
    CGFloat right = -self.marginArray[3].floatValue;
    
    MTWeakSelf;
    //因为startLayout可能会被多次调用，所以这里使用mas_remakeConstraints
    [collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(top);
        make.left.equalTo(weakSelf).offset(left);
        make.bottom.equalTo(weakSelf).offset(bottom);
        make.right.equalTo(weakSelf).offset(right);
    }];
}

- (void)scrollView:(UICollectionView *)collectionView{
    if (self.scrollerBlock) {
        self.scrollerBlock(collectionView.contentOffset);
    }
}

//获取视图高度
- (CGFloat)getmtBaseHeight{
    return (_viewHeight = [self calculateBaseHeight]);
}

- (void)setCollectionViewSource:(NSArray *)collectionViewSource{
    _collectionViewSource = [NSMutableArray arrayWithArray:collectionViewSource];
    [self.collectionView reloadData];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //如果设置itemWidth就使用itemWidth,如果未设置，则由 (（宽度 - 左右间距 - 空隙）/ 个数 ) 得出
    CGFloat cellWidth = (self.itemWidth > 0 ? self.itemWidth : (self.width  - self.marginArray[1].floatValue - self.marginArray[3].floatValue - (ceilf(self.numInaLine) - 1) * self.horizonSpace) / self.numInaLine);
    
    //计算itemSize
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(cellWidth, self.itemHeight);
    self.collectionView.collectionViewLayout = layout;
}

#pragma mark - Collectionview代理数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionViewSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MTBaseCollectionCell *cell = nil;
    if (self.dequeCell) {
        cell =  self.dequeCell(collectionView, indexPath);
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:mtBaseCollectionViewCell forIndexPath:indexPath];
    }
    NSAssert([cell isKindOfClass:[MTBaseCollectionCell class]], @"cell必须为MTBaseCollectionCell的子类");
    cell.cellModel = self.collectionViewSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectItem) {
        self.selectItem(indexPath, collectionView);
    }
}

#pragma mark - ScrollView的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self scrollView:self.collectionView];
}

@end
