//
//  HttpClientConfig.m
//  TestGitHub
//
//  Created by MenThu on 16/7/20.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "HttpClientConfig.h"

static HttpClientConfig *_config = nil;

@implementation HttpClientConfig


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _config = [[self alloc] init];
    });
    return _config;
}


@end
