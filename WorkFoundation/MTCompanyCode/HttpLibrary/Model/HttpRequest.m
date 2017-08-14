//
//  JZRequest.m
//  TestGitHub
//
//  Created by MenThu on 16/7/20.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "HttpRequest.h"
#import "NSString+isExist.h"

#define IS_JZ100 1

@implementation HttpRequest

+ (instancetype)requestWithPath:(NSString *)path {
    NSAssert1([path isExist], @"%@不能为空", @"path");
    
    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.path = path;
    return request;
}

+ (instancetype)requestWithPath:(NSString *)path contentKey:(NSString *)key {
    HttpRequest *request = [self requestWithPath:path];
    request.contentKey = key;
    return request;
}

@end
