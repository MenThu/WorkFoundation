//
//  ToolView.m
//  CGLearn
//
//  Created by MenThu on 16/6/29.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "ToolView.h"
#import "Masonry.h"
#define BtnWidth [UIScreen mainScreen].bounds.size.width / 4

@interface ToolView ()

@property (strong, nonatomic)NSArray *btnArray;

@end

@implementation ToolView

- (void)awakeFromNib
{
    [self configUI];
}

- (void)configUI
{
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"未选中" forState:UIControlStateNormal];
    [btn1 setTitle:@"选中" forState:UIControlStateSelected];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"未选中" forState:UIControlStateNormal];
    [btn2 setTitle:@"选中" forState:UIControlStateSelected];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setTitle:@"未选中" forState:UIControlStateNormal];
    [btn3 setTitle:@"选中" forState:UIControlStateSelected];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 setTitle:@"未选中" forState:UIControlStateNormal];
    [btn4 setTitle:@"选中" forState:UIControlStateSelected];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn5 setTitle:@"未选中" forState:UIControlStateNormal];
    [btn5 setTitle:@"选中" forState:UIControlStateSelected];
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn6 setTitle:@"未选中" forState:UIControlStateNormal];
    [btn6 setTitle:@"选中" forState:UIControlStateSelected];
    
    
    self.btnArray = @[btn1, btn2, btn3, btn4, btn5, btn6];
    
    [self.btnArray makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:[UIColor grayColor]];
    
    [self addSubview:btn1];
    [self addSubview:btn2];
    [self addSubview:btn3];
    [self addSubview:btn4];
    [self addSubview:btn5];
    [self addSubview:btn6];
    
    WeakSelf;
    
    [self.btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(btn2.mas_left);
        make.width.mas_equalTo(BtnWidth);
        make.height.equalTo(weakSelf);
    }];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btn3.mas_left);
        make.width.equalTo(btn1);
    }];
    
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btn4.mas_left);
        make.width.equalTo(btn1);
    }];
    
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btn5.mas_left);
        make.width.equalTo(btn1);
    }];
    
    [btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btn6.mas_left);
        make.width.equalTo(btn1);
    }];
    
    [btn6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.width.equalTo(btn1);
    }];
    
}

@end
