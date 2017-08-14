//
//  MTBaseCollectionCell.h
//  rrmjMT
//
//  Created by MenThu on 2016/12/10.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTBaseCollectionCell : UICollectionViewCell

@property (nonatomic, weak) id cellModel;

//自定义子视图
- (void)customView;

//根据数据更新子视图
- (void)updateCustomView;

@end
