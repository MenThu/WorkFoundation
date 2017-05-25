//
//  MTBaseView.m
//  artapp
//
//  Created by MenThu on 17/5/18.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "MTBaseView.h"

@implementation MTBaseView

+ (instancetype)loadView{
    NSString *bundleString = NSStringFromClass([self class]);
    return [[NSBundle mainBundle] loadNibNamed:bundleString owner:self options:nil].lastObject;
}

- (CGFloat)getViewHeightWith:(id)Model{
    NSAssert(NO, @"子类必须覆盖此方法");
    return 0;
}

@end
