//
//  HttpClientConfig.h
//  TestGitHub
//
//  Created by MenThu on 16/7/20.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpClientConfig : NSObject

/**
 *  请使用次方法获取实例，并网络请求前设置好相关配置。
 *
 *  @return Config对象。
 */
kSingletonH

/**
 *  根URL，后拼接接口地址。
 */
@property (nonatomic, copy) NSURL *baseURL;

/**
 *  统一的超时时间设置。默认15s。
 */
@property (nonatomic, assign) NSTimeInterval timeout;

/**
 *  包含内容的key值
 */
@property (nonatomic, copy) NSString *contentKey;

/**
 *  服务器返回成功的status码。默认为0；
 */
@property (nonatomic, assign) NSInteger successStatus;

@end
