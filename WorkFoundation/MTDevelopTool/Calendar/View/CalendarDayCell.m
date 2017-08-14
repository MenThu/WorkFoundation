//
//  CalendarDayCell.m
//  artapp
//
//  Created by MenThu on 17/6/20.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "CalendarDayCell.h"
#import "CalendarDay.h"

#import "TestModel.h"

@interface CalendarDayCell ()

@property (nonatomic, weak) UILabel *dayLabel;
@property (nonatomic, weak) CAShapeLayer *circleLayer;
@property (nonatomic, weak) CAShapeLayer *hintLayer;

@end

@implementation CalendarDayCell

- (void)customView{
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.fillColor = [UIColor redColor].CGColor;
    [self.contentView.layer addSublayer:(_circleLayer = circleLayer)];
    
    CAShapeLayer *hintLayer = [CAShapeLayer layer];
    hintLayer.fillColor = [UIColor redColor].CGColor;
    [self.contentView.layer addSublayer:(_hintLayer = hintLayer)];
    
    UILabel *dayLabel = [UILabel new];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dayLabel.font = [UIFont systemFontOfSize:12.f];
    dayLabel.textColor = [UIColor blackColor];
    dayLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:(_dayLabel = dayLabel)];
}

- (void)updateCustomView{
    TestModel *model = (TestModel *)self.cellModel;
    self.dayLabel.text = [NSString stringWithFormat:@"%@", @(model.day)];
    if (model.previouOrCurrentOrNext == 0) {
        //当月
        if (model.isSelect) {
            self.circleLayer.hidden = NO;
            self.dayLabel.textColor = [UIColor whiteColor];
        }else{
            self.circleLayer.hidden = YES;
            if (model.isNow) {
                self.dayLabel.textColor = [UIColor redColor];
            }else{
                self.dayLabel.textColor = [UIColor blackColor];
            }
        }
    }else{
        //非当月
        self.dayLabel.textColor = [UIColor grayColor];
        self.circleLayer.hidden = YES;
    }
    self.hintLayer.hidden = (model.isHaveMatter == 0 ? YES : NO);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.contentView.width * 0.6;
    CGFloat height = width;
    CGFloat x = self.contentView.width/2 - width/2;
    self.dayLabel.frame = CGRectMake(x, 5, width, height);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:self.dayLabel.frame];
    self.circleLayer.path = circlePath.CGPath;
    
    CGFloat widthForHint = 5;
    CGFloat yForHint = self.contentView.height - 3 - widthForHint;
    CGRect frameForHint = CGRectMake(self.contentView.centerX-widthForHint/2, yForHint, widthForHint, widthForHint);
    UIBezierPath *hintLayerPath = [UIBezierPath bezierPathWithOvalInRect:frameForHint];
    self.hintLayer.path = hintLayerPath.CGPath;
}

@end
