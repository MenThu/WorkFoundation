//
//  MTTableViewCell.m
//  MTCollectionView
//
//  Created by MenThu on 2017/12/6.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import "MTTableViewCell.h"

@implementation MTTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self configContentView];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configContentView];
    }
    return self;
}

/**
 *  配置内容视图
 **/
- (void)configContentView{
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor clearColor];
}

/**
 *  更新内容视图
 **/
- (void)updateContentView{
    
}

#pragma mark - Setter
- (void)setCellModel:(MTTableViewCellModel *)cellModel{
    _cellModel = cellModel;
    [self updateContentView];
}

@end
