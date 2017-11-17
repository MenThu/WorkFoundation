//
//  ShadowCornerRadius.m
//  TestProxy
//
//  Created by MenThu on 2017/11/16.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import "ShadowCornerRadius.h"

@implementation ShadowCornerRadius

- (instancetype)init{
    if (self = [super init]) {
        self.cornerRadius = 3.f;
        self.isMask2BoundsOn = YES;
        self.shadowOffset = CGSizeZero;
        self.shadowColor = [UIColor blackColor];
        self.shadowRadius = 5.f;
        self.shadowOpacity = 0.7;
    }
    return self;
}

@end
