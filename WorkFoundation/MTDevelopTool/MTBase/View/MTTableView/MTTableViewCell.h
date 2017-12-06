//
//  MTTableViewCell.h
//  MTCollectionView
//
//  Created by MenThu on 2017/12/6.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTTableViewCellModel.h"

@interface MTTableViewCell : UITableViewCell

/**
 *  数据源
 **/
@property (nonatomic, weak) MTTableViewCellModel *cellModel;

/**
 *  配置内容视图
 **/
- (void)configContentView;

/**
 *  更新内容视图
 **/
- (void)updateContentView;

@end
