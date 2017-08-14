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


kSingletonM

- (instancetype)init{
    if (self = [super init]) {
        self.timeout = 15;
        self.successStatus = 0;
    }
    return self;
}


@end
