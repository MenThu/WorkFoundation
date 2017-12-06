//
//  MTTableView.h
//  MTCollectionView
//
//  Created by MenThu on 2017/12/6.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTRegisterModel.h"
#import "MTTableViewCellModel.h"

@interface MTTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

/**
 *  cell重用字符串
 **/
@property (nonatomic, strong) NSArray <MTRegisterModel *> *registerCellArray;

/**
 *  数据源
 **/
@property (nonatomic, strong) NSMutableArray <MTTableViewCellModel *> *tableViewSource;

/**
 *  配置子视图
 **/
- (void)configView;

@end
