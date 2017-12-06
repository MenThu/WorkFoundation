//
//  MTCollectionViewCell.m
//  rrmjMT
//
//  Created by MenThu on 2016/12/10.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTCollectionViewCell.h"

@implementation MTCollectionViewCell

#pragma mark - LifeCircle
- (void)awakeFromNib{
    [super awakeFromNib];
    [self configContentView];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configContentView];
    }
    return self;
}

#pragma mark - Public
- (void)configContentView{
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)updateContentView{
    
}

- (CGSize)getSizeWithModel:(id)model{
    NSAssert(NO, @"子类需要覆盖此方法");
    return CGSizeZero;
}

#pragma mark - Setter
- (void)setCellModel:(id)cellModel{
    _cellModel = cellModel;
    [self updateContentView];
}

@end
