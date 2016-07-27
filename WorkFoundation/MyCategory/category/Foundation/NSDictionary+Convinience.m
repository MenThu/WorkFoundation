//
//  NSDictionary+Convinience.m
//  CGLearn
//
//  Created by MenThu on 16/7/18.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "NSDictionary+Convinience.h"

@implementation NSDictionary (Convinience)

- (BOOL)haveKey:(NSString*)keyString
{
    NSArray *keyArray = [self allKeys];
    for (NSString *subKeyString in keyArray) {
        if ([subKeyString isEqualToString:keyString]) {
            return YES;
        }
    }
    return NO;
}

@end
