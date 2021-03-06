//
//  JZResponse.m
//  TestGitHub
//
//  Created by MenThu on 16/7/20.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "HttpResponse.h"

NSString *const kHttpResponseDefaultString = @"com.MenThu.error.init";
NSInteger const kHttpResponseDefaultCode = 666;

@implementation HttpResponse

- (instancetype)init
{
    if (self = [super init]) {
        _success = NO;
        _msg = @"初始化msg";
        _error = [NSError errorWithDomain:kHttpResponseDefaultString code:kHttpResponseDefaultCode userInfo:@{NSLocalizedDescriptionKey : @"Error初始化"}];
        _body = @{@"DefaultKey":@"DefaultValue"};
        _emptyResult = YES;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", @{@"status":@(self.success), @"msg":self.msg, @"error":self.error,@"rawResult":self.body}];
}

@end
