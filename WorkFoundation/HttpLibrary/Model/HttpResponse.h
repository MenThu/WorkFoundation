//
//  JZResponse.h
//  TestGitHub
//
//  Created by MenThu on 16/7/20.
//  Copyright © 2016年 官辉. All rights reserved.
//

#if __has_include(<MJExtension/MJExtension.h>)

#import "MJExtension.h"
#define MJExist 1

#else

#import <Foundation/Foundation.h>
#define MJExist 0

#endif

@interface HttpResponse<T> : NSObject

/**
 *  -1 为 失败
 */
@property(nonatomic, assign) NSInteger status;

/**
 *  提示信息
 */
@property(nonatomic, copy) NSString *msg;

/**
 *  单个实体或实体的集合(可选)
 */
@property(nonatomic, strong) T result;

/**
 *  result的原始json类型
 */
@property(nonatomic, strong) id rawResult;

/**
 *  服务器的result是否是个空的.
 */
@property(nonatomic, assign, getter=isEmptyResult) BOOL emptyResult;

/**
 *  数据是否来自缓存
 */
@property(nonatomic, assign) BOOL fromCache;

/**
 *  错误
 */
@property(nonatomic, strong) NSError *error;


@end
