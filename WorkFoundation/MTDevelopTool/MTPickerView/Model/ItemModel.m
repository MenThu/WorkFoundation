//
//  ItemModel.m
//  TestPicker
//
//  Created by MenThu on 16/8/19.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel


- (instancetype)init
{
    if (self = [super init]) {
        self.itemName = @"";
        self.nextArray = nil;
    }
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", @{@"itemName":self.itemName, @"nextArray":(self.nextArray == nil ? @"nil" : self.nextArray)}];
}

@end
