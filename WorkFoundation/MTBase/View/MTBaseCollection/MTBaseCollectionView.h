//
//  MTBaseCollectionView.h
//  rrmjMT
//
//  Created by MenThu on 2016/12/10.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTBaseCollectionView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

//collectionView的frame内，一行的个数
@property (nonatomic, assign) CGFloat numInaLine;

//每一个Cell的水平距离 [默认5]
@property (nonatomic, assign) CGFloat horizonSpace;

//每一个Cell的垂直距离 [默认5]
@property (nonatomic, assign) CGFloat verticalSpace;

//Collection距离 上，左，下，右的距离,默认[5,5,5,5]
@property (nonatomic, strong) NSArray <NSNumber *> *marginArray;

//UICollectinView的Section内边距，默认[0,0,0,0]
@property (nonatomic, assign) UIEdgeInsets sectionInset;

//展示的行数 [默认一行]
@property (nonatomic, assign) NSInteger numofLine;

//水平滚动方向 [默认YES]
@property (nonatomic, assign) BOOL isScrollDirectionHorizon;

//cell的高度[默认50]
@property (nonatomic, assign) CGFloat itemHeight;

//cell的宽度，默认0，不适用
@property (nonatomic, assign) CGFloat itemWidth;

//cell重用的字符串
@property (nonatomic, copy) NSString *cellClassName;

//cell是否来自于xib，默认为YES
@property (nonatomic, assign) BOOL isFromXib;

//数据源
@property (nonatomic, weak) NSArray *collectionViewSource;

//点击Item的block
@property (nonatomic, copy) void (^selectItem) (NSIndexPath *indexPath, UICollectionView *selectView);

//添加子类控件
- (void)customView;

//初始化变量
- (void)initVariable;

//开始布局
- (void)startLayout;

//获取视图高度
- (CGFloat)getmtBaseHeight;

//滚动调用的函数，子类可以复写
- (void)scrollView:(UICollectionView *)collectionView;

@end
