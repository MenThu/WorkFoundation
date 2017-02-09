//
//  NSDictionary+decription.m
//  IMTestProject
//
//  Created by MenThu on 2016/10/13.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "NSDictionary+Description.h"

@implementation NSDictionary (Description)


- (NSString *)descriptionWithLocale:(id)locale
{
    NSArray *allKeys = [self allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
    for (NSString *key in allKeys) {
        id value= self[key];
        [str appendFormat:@"\t \"%@\" = %@,\n",key, value];
    }
    [str appendString:@"}"];
    
    return str;
}

@end
