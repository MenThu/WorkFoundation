//
//  MTCollectionViewCell.h
//  rrmjMT
//
//  Created by MenThu on 2016/12/10.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTCollectionViewCell : UICollectionViewCell

/**
 *  统一的数据模型
 **/
@property (nonatomic, weak) id cellModel;

/**
 *  自定义内容视图
 **/
- (void)configContentView;

/**
 *  根据数据源更新内容
 **/
- (void)updateContentView;

/**
 *  通过模型获取大小
 **/
- (CGSize)getSizeWithModel:(id)model;

@end
