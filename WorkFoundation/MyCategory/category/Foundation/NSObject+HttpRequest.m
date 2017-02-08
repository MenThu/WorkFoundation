//
//  NSObject+HttpRequest.m
//  TestGitHub
//
//  Created by MenThu on 16/7/21.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "NSObject+HttpRequest.h"
#import "NSString+isExist.h"
#import "MyLog.h"
#import "WorkFoundation.h"


@implementation NSObject (HttpRequest)

+ (void)post:(HttpRequest *)request blockView:(UIView *)blockView finish:(finishBlock)finishBlock
{
    [[HttpClient sharedInstance] post:request blockView:blockView finish:^(HttpResponse *response) {
        //这里是未处理的业务数据 将rawData处理成rezultData
        if (!response.emptyResult) {
            //服务端返回不为空
            finishBlock([self dealDataWith:response ContentKey:request.contentKey]);
        }else{
            finishBlock(response);
        }
    }];
}

+ (HttpResponse *)dealDataWith:(HttpResponse *)response ContentKey:(NSString *)keyString
{
    id result = nil;
    if ([keyString isExist] && response.rawResult && [response.rawResult isKindOfClass:[NSDictionary class]]) {
        result = response.rawResult[keyString];
    }else{
       result = response.rawResult;
    }
    if (result && ![result isKindOfClass:[NSNull class]]) { //判断服务器返回的主数据是否为空
        response.emptyResult = NO;
        if ([result isKindOfClass:[NSArray class]]) {    //需要的是数组，并且result确实为数组
            response.result = [self mj_objectArrayWithKeyValuesArray:result];
        } else if ([result isKindOfClass:[NSDictionary class]]) {   //需要的是字典，并且result确实为字典
            response.result = [self mj_objectWithKeyValues:result];
        }
    } else {
        response.emptyResult = YES;
    }
    return response;
}

@end
