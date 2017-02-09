//
//  NSArray+decription.m
//  IMTestProject
//
//  Created by MenThu on 2016/10/13.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "NSArray+Description.h"

@implementation NSArray (Description)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu (\n", (unsigned long)self.count];
    
    for (id obj in self) {
        [str appendFormat:@"\t%@, \n", obj];
    }
    
    [str appendString:@")"];
    
    return str;
}

@end
