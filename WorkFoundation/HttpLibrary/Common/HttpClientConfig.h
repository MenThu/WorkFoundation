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
 *  根URL，后拼接接口地址。
 */
@property (nonatomic, copy) NSURL *baseURL;

/**
 *  统一的超时时间设置。默认15s。
 */
@property (nonatomic, assign) NSTimeInterval timeout;


/**
 *  返回的业务数据Key值
 */
@property (nonatomic, copy) NSString *returnContentKey;

/**
 *  服务器反悔成功的status码。默认为0；
 */
@property (nonatomic, assign) NSInteger successStatus;

/**
 *  请使用次方法获取实例，并网络请求前设置好相关配置。
 *
 *  @return Config对象。
 */
+ (instancetype)sharedInstance;

@end
