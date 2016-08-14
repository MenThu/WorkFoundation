//
//  NSDictionary+Convinience.h
//  CGLearn
//
//  Created by MenThu on 16/7/18.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Convinience)

- (BOOL)haveKey:(NSString*)keyString;

- (NSData *)convertToData;

@end
