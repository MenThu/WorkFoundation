//
//  MTTextView.m
//  JiangL
//
//  Created by MenThu on 2017/12/7.
//  Copyright © 2017年 Aladdin. All rights reserved.
//

#import "MTTextView.h"

@interface MTTextView ()

@property (nonatomic, weak, readwrite) UILabel *placeHoldLabel;

@end

@implementation MTTextView

#pragma mark - LifeCircle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (void)dealloc{
    MyLog(@"MTTextView die");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat originX = 4;
    CGFloat originY = 7;
    CGFloat width = self.width-2*originX;
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    CGFloat suitHeight = [self.placeHoldLabel sizeThatFits:maxSize].height;
    self.placeHoldLabel.frame = CGRectMake(originX, originY, width, suitHeight);
}

#pragma mark - Private
- (void)configView{
    UILabel *placeHoldLabel = [UILabel new];
    placeHoldLabel.numberOfLines = 0.f;
    placeHoldLabel.userInteractionEnabled = NO;
    [self addSubview:(_placeHoldLabel = placeHoldLabel)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)textDidChange{
    self.placeHoldLabel.hidden = [self.text isExist];
}

#pragma mark - Setter
- (void)setPlaceHoldText:(NSString *)placeHoldText{
    self.placeHoldLabel.text = placeHoldText;
    [self setNeedsLayout];
}

- (void)setPlaceHoldColor:(UIColor *)placeHoldColor{
    self.placeHoldLabel.textColor = placeHoldColor;
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeHoldLabel.font = font;
}

@end
