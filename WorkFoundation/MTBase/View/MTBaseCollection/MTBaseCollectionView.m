//
//  MTBaseCollectionView.m
//  rrmjMT
//
//  Created by MenThu on 2016/12/10.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseCollectionView.h"
#import "MTBaseCollectionCell.h"

static NSString *cellReuseId = @"cellReuseId";
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
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    self.numInaLine = 1;
    self.horizonSpace = self.verticalSpace = 0;
    self.numofLine = 1;
    self.isFromXib = YES;
    self.isScrollDirectionHorizon = YES;
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
    NSAssert([self.cellClassName isExist], @"cellClassName不能为空！！！");
    
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
    
    
    if (self.isFromXib) {
        [collectionView registerNib:[UINib nibWithNibName:self.cellClassName bundle:nil] forCellWithReuseIdentifier:cellReuseId];
    }else{
        [collectionView registerClass:NSClassFromString(self.cellClassName) forCellWithReuseIdentifier:cellReuseId];
    }
    
    CGFloat top = self.marginArray[0].floatValue;
    CGFloat left = self.marginArray[1].floatValue;
    CGFloat bottom = -self.marginArray[2].floatValue;
    CGFloat right = -self.marginArray[3].floatValue;
    
    MJWeakSelf;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(top);
        make.left.equalTo(weakSelf).offset(left);
        make.bottom.equalTo(weakSelf).offset(bottom);
        make.right.equalTo(weakSelf).offset(right);
    }];
}

//获取视图高度
- (CGFloat)getmtBaseHeight{
    return (_viewHeight = [self calculateBaseHeight]);
}

- (void)setCollectionViewSource:(NSArray *)collectionViewSource{
    if (collectionViewSource.count <= 0) {
        return;
    }
    _collectionViewSource = collectionViewSource;
    [self.collectionView reloadData];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //因为我设置numInaLine为cgfloat，所以这里numInaLine需要向上取整
    CGFloat cellWidth = (self.width  - self.marginArray[1].floatValue - self.marginArray[3].floatValue - (ceilf(self.numInaLine) - 1) * self.horizonSpace) / self.numInaLine;
    
    //计算itemSize
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(cellWidth, self.itemHeight);
    self.collectionView.collectionViewLayout = layout;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionViewSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MTBaseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseId forIndexPath:indexPath];
    NSAssert([cell isKindOfClass:[MTBaseCollectionCell class]], @"cell必须为MTBaseCollectionCell的子类");
    cell.cellModel = self.collectionViewSource[indexPath.row];
    return cell;
}

@end
