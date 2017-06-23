//
//  CalendarDayCell.m
//  artapp
//
//  Created by MenThu on 17/6/20.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "CalendarDayCell.h"
#import "CalendarDay.h"

@interface CalendarDayCell ()

@property (nonatomic, weak) UILabel *dayLabel;
@property (nonatomic, weak) UIView *hintView;
@property (nonatomic, weak) CAShapeLayer *circleLayer;

@end

@implementation CalendarDayCell

- (void)customView{
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.fillColor = [UIColor redColor].CGColor;
    [self.contentView.layer addSublayer:(_circleLayer = circleLayer)];
    
    UILabel *dayLabel = [UILabel new];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dayLabel.font = [UIFont systemFontOfSize:12.f];
    dayLabel.textColor = [UIColor blackColor];
    dayLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:(_dayLabel = dayLabel)];
    
    UIView *hintView = [UIView new];
    hintView.backgroundColor = [UIColor redColor];
    CGFloat hintViewWidth = 5.f;
    UIBezierPath *hintMaskLayerPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, hintViewWidth, hintViewWidth)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = hintMaskLayerPath.CGPath;
    hintView.layer.mask = maskLayer;
    [self.contentView addSubview:(_hintView = hintView)];
    
    MTWeakSelf;
    [hintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(hintViewWidth, hintViewWidth));
    }];
}

- (void)updateCustomView{
    CalendarDay *model = (CalendarDay *)self.cellModel;
    self.dayLabel.text = [NSString stringWithFormat:@"%@", @(model.day)];
    if (model.isSelect) {
        //被选中
        self.circleLayer.hidden = NO;
        self.dayLabel.textColor = [UIColor whiteColor];
    }else{
        self.circleLayer.hidden = YES;
        if (model.previouOrCurrentOrNext != 0) {
            //不属于这个月
            self.dayLabel.textColor = [UIColor grayColor];
        }else{
            self.dayLabel.textColor = [UIColor blackColor];
            if (model.isNow) {
                self.dayLabel.textColor = [UIColor redColor];
            }
        }
    }
    self.hintView.hidden = (model.isHaveMatter == 0 ? YES : NO);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.contentView.width * 0.6;
    CGFloat height = width;
    CGFloat x = self.contentView.width/2 - width/2;
    self.dayLabel.frame = CGRectMake(x, 5, width, height);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:self.dayLabel.frame];
    self.circleLayer.path = circlePath.CGPath;
}

@end
