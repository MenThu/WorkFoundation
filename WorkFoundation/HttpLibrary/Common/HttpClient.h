//
//  HttpClient.h
//  TestGitHub
//
//  Created by MenThu on 16/7/20.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "HttpRequest.h"
#import "HttpResponse.h"

FOUNDATION_EXTERN NSString *const kHttpClientErrorDomain;

typedef void(^finishBlock)(HttpResponse* response);

@interface HttpClient : NSObject


@property (nonatomic, strong, readonly) AFHTTPSessionManager *manager;

+ (instancetype)sharedInstance;

- (NSURLSessionTask *)post:(HttpRequest *)request finish:(finishBlock)reponse fail:(finishBlock)failMsg error:(finishBlock)errorBlock isShowProgress:(BOOL)isShow;

@end
