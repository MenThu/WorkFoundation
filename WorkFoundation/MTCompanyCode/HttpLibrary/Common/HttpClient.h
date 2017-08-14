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
#import "Singleton.h"

FOUNDATION_EXTERN NSString *const kHttpClientErrorDomain;

typedef void(^finishBlock)(HttpResponse* response);

@interface HttpClient : NSObject

kSingletonH;

/**
 *  get请求
 *  @params request 请求
 *  @params reponse 返回的block
 **/
- (NSURLSessionTask *)get:(HttpRequest *)request blockView:(UIView *)blockView finish:(finishBlock)reponse;

/**
 *  post请求
 *  @params request 请求
 *  @params reponse 返回的block
 **/
- (NSURLSessionTask *)post:(HttpRequest *)request blockView:(UIView *)blockView finish:(finishBlock)reponse;

/**
 *  上传文件
 *  @params request 请求
 *  @params reponse 返回的block
 **/
- (NSURLSessionTask *)uploadWith:(HttpRequest *)request blockView:(UIView *)blockView finish:(finishBlock)reponse;

@end
