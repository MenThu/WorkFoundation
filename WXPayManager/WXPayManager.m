//
//  WXPayManager.m
//  TestLabel
//
//  Created by MenThu on 16/9/6.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "WXPayManager.h"
//wxb4ba3c02aa476ea1
NSString *const appId = @"wxd0d75a2b4a913f46";
NSString *const registerDes = @"注册微信支付";

@interface WXPayManager () <WXApiDelegate>

@property (nonatomic, copy) void(^returnBlock)(NSDictionary *params);

@end

@implementation WXPayManager


+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static WXPayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXPayManager alloc] init];
        [instance registerAppIdWith:appId WithDescription:registerDes];
        
    });
    return instance;
}

#pragma mark - 公开方法
- (void)sendPayReques:(PayReq *)payParams payRezult:(void (^)(NSDictionary* respones))rezultBlcok
{
    self.returnBlock = rezultBlcok;
    [WXApi sendReq:payParams];
}

- (BOOL)handleUrl:(NSURL *)appUrl
{
    return [WXApi handleOpenURL:appUrl delegate:[WXPayManager shareManager]];
}

- (BOOL)isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}

#pragma mark - 内部方法
- (void)registerAppIdWith:(NSString *)appId WithDescription:(NSString *)description
{
    [WXApi registerApp:appId withDescription:description];
}

- (void)onResp:(BaseResp *)resp {
    NSDictionary *returnParams;
    if([resp isKindOfClass:[PayResp class]]){
        NSString *strMsg;
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付成功";
            }
                break;
            case WXErrCodeCommon:
            {
                strMsg = @"普通错误类型";
            }
                break;
            case WXErrCodeUserCancel:
            {
                strMsg = @"用户点击取消并返回";
            }
                break;
            case WXErrCodeSentFail:
            {
                strMsg = @"发送失败";
            }
                break;
            case WXErrCodeAuthDeny:
            {
                strMsg = @"授权失败";
            }
                break;
            case WXErrCodeUnsupport:
            {
                strMsg = @"微信不支持";
            }
                break;
        }
        returnParams = @{@"errCode":@(resp.errCode),@"errMsg":strMsg};
    }else{
        returnParams = @{@"errCode":@(-1),@"errMsg":[NSString stringWithFormat:@"%s", __FILE__]};
    }
    if (self.returnBlock) {
        self.returnBlock(returnParams);
    }
}

@end
