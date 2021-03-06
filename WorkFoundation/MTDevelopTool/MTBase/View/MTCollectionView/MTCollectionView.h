//
//  MTCollectionView.h
//  MTCollectionView
//
//  Created by MenThu on 2017/12/4.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTRegisterModel.h"

@interface MTCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/**
 *  cell重用字符串
 **/
@property (nonatomic, strong) NSArray <MTRegisterModel *> *registerCellArray;

/**
 *  数据源
 **/
@property (nonatomic, strong) NSMutableArray *collectionSource;

/**
 *  配置子视图
 **/
- (void)configView;

@end
