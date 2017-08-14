//
//  MTBaseCollectionCell.m
//  rrmjMT
//
//  Created by MenThu on 2016/12/10.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseCollectionCell.h"

@implementation MTBaseCollectionCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self configBaseContentView];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configBaseContentView];
    }
    return self;
}

- (void)configBaseContentView{
    self.contentView.backgroundColor = [UIColor clearColor];
    [self customView];
}

- (void)customView{
    
}

- (void)setCellModel:(id)cellModel{
    _cellModel = cellModel;
    [self updateCustomView];
}

- (void)updateCustomView{
    
}


@end
