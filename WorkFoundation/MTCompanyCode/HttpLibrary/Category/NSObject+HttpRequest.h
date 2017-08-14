//
//  NSObject+HttpRequest.h
//  TestGitHub
//
//  Created by MenThu on 16/7/21.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpLibrary.h"

@interface NSObject (HttpRequest)

/**
 *  post请求
 *  @params request 请求
 *  @params blockView 如果遮挡则传递需要遮挡的view，可以为nil
 *  @params finishBlock 成功的回调
 **/
+ (void)post:(HttpRequest *)request blockView:(UIView *)blockView finish:(finishBlock)finishBlock;

/**
 *  get请求
 *  @params request 请求
 *  @params blockView 如果遮挡则传递需要遮挡的view，可以为nil
 *  @params finishBlock 成功的回调
 **/
+ (void)get:(HttpRequest *)request blockView:(UIView *)blockView finish:(finishBlock)finishBlock;

@end
