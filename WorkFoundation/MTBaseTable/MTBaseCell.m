//
//  MTBaseCell.m
//  TestStoryboard
//
//  Created by MenThu on 2016/11/21.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseCell.h"

@implementation MTBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configCell];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configCell];
    }
    return self;
}

- (void)configCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
