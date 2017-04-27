//
//  MTFunc.m
//  MTTest
//
//  Created by MenThu on 2017/3/13.
//  Copyright © 2017年 官辉. All rights reserved.
//

#import "MTFunc.h"

@implementation MTFunc
    
CGSize MTScreenSize() {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}

@end
