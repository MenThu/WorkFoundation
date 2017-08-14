//
//  MTBaseCollectionVC.h
//  rrmjMT
//
//  Created by MenThu on 2016/12/12.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseVC.h"
FOUNDATION_EXTERN NSString *const mtBaseCollectionControllerCell;

@interface MTBaseCollectionVC : MTBaseVC

/**
    数据源
 **/
@property (nonatomic, strong) NSArray *collectionViewSource;

/**
    本类的collectionView
 **/
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

/**
 *  collectionViewCell的Class名字
 **/
@property (nonatomic, copy) NSString *cellClassName;

/**
 *  cell是否来自于Xib，默认yes
 **/
@property (nonatomic, assign) BOOL isFromXib;

/**
 *  Collectionview 距离self.view四周的边距，默认[0,0,0,0]
 **/
@property (nonatomic, strong) NSArray <NSNumber *> *collectionViewMarginArray;

/**
 *  cell的宽度[默认50]
 **/
@property (nonatomic, assign) CGFloat itemWidth;

/**
 *  cellItem的高度[默认50]
 **/
@property (nonatomic, assign) CGFloat itemHeight;

/**
 *  一行中，每个cellItem的水平距离[默认0]
 **/
@property (nonatomic, assign) CGFloat horizonSpace;

/**
 *  每一行的垂直距离[默认0]
 **/
@property (nonatomic, assign) CGFloat verticalSpace;

/**
 *  水平滚动方向 [默认YES]
 **/
@property (nonatomic, assign) BOOL isScrollDirectionHorizon;

/**
 *  变量初始化的工作，子类需要覆盖;
 **/
- (void)initVariable;

/**
 *  UICollectionview滚动的代理方法
 **/
- (void)scrollViewMove:(CGPoint)contentOffset view:(UICollectionView *)scrollView;

/**
 *  获取cell的代理方法,子类可以复写
 **/
- (MTBaseCollectionCell *)cellForIndexPath:(NSIndexPath *)indexPath view:(UICollectionView *)collectionView;

/**
 *  点击uicollectionview
 **/
- (void)selectIndexPath:(NSIndexPath *)indexPath view:(UICollectionView *)collectionView;

@end
