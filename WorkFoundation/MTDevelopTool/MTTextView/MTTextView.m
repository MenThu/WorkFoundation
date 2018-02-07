//
//  MTTextView.m
//  JiangL
//
//  Created by MenThu on 2017/12/7.
//  Copyright © 2017年 Aladdin. All rights reserved.
//

#import "MTTextView.h"
#import "PublicHeader.h"

@interface MTTextView ()

@property (nonatomic, weak, readwrite) UILabel *placeHoldLabel;
@property (nonatomic, assign) CGPoint placeOrigin;//placeHoldLabel的origin

@end

@implementation MTTextView

#pragma mark - LifeCircle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self configView];
}

- (void)dealloc{
    NSLog(@"MTTextView die");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width - 2*self.placeOrigin.x;
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    CGFloat suitHeight = [self.placeHoldLabel sizeThatFits:maxSize].height;
    self.placeHoldLabel.frame = CGRectMake(self.placeOrigin.x, self.placeOrigin.y, width, suitHeight);
}

#pragma mark - Private
- (void)configView{
    [self adjustPlaceHoldLabelOrgin];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)textDidChange{
    self.placeHoldLabel.hidden = [self.text isExist];
}

- (void)adjustPlaceHoldLabelOrgin{
    CGRect frame = [self caretRectForPosition:self.selectedTextRange.start];
    if (CGRectEqualToRect(frame, CGRectZero)) {
        self.placeOrigin = CGPointMake(4, 7);
    }else{
        self.placeOrigin = frame.origin;
    }
}

#pragma mark - Getter
- (UILabel *)placeHoldLabel{
    if (_placeHoldLabel == nil) {
        UILabel *placeHoldLabel = [UILabel new];
        placeHoldLabel.numberOfLines = 0.f;
        placeHoldLabel.userInteractionEnabled = NO;
        [self addSubview:(_placeHoldLabel = placeHoldLabel)];
    }
    return _placeHoldLabel;
}

#pragma mark - Setter
- (void)setPlaceHoldText:(NSString *)placeHoldText{
    _placeHoldText = placeHoldText;
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

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    [super setTextAlignment:textAlignment];
    self.placeHoldLabel.textAlignment = textAlignment;
}

@end
