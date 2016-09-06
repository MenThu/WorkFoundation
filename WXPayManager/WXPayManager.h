//
//  WXPayManager.h
//  TestLabel
//
//  Created by MenThu on 16/9/6.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "Singleton.h"

FOUNDATION_EXTERN NSString *const appId;
FOUNDATION_EXTERN NSString *const registerDes;

@interface WXPayManager : NSObject

+ (instancetype)shareManager;

- (void)sendPayReques:(PayReq *)payParams payRezult:(void (^)(NSDictionary* respones))rezultBlcok;

- (BOOL)handleUrl:(NSURL *)appUrl;

- (BOOL)isWXAppInstalled;

@end
