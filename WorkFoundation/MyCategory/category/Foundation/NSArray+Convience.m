//
//  NSArray+Convience.m
//  FileManager
//
//  Created by MenThu on 16/8/15.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "NSArray+Convience.h"

@implementation NSArray (Convience)

- (NSArray *)RemoveDuplicate
{
    return [[NSSet setWithArray:self] allObjects];
}

@end
