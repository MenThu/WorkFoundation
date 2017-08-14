//
//  HttpClient.m
//  TestGitHub
//
//  Created by MenThu on 16/7/20.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "HttpClient.h"
#import "HttpClientConfig.h"
#import "NSString+isExist.h"
#import "MBProgressHUD.h"
NSString *const kHttpClientErrorDomain = @"com.MenThu.errorDomain";
static HttpClient *_httpClient = nil;

@interface HttpClient ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation HttpClient

kSingletonM

- (instancetype)init {
    if (self = [super init]) {
        /**
            https适配
         **/
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        policy.allowInvalidCertificates = NO;
        policy.validatesDomainName = NO;
        
        /**
            超时时间
         **/
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = [HttpClientConfig sharedInstance].timeout;
        
        _manager= [[AFHTTPSessionManager alloc] initWithBaseURL:[HttpClientConfig sharedInstance].baseURL sessionConfiguration:configuration];
        _manager.securityPolicy = policy;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    }
    return self;
}

- (NSURLSessionTask *)get:(HttpRequest *)request blockView:(UIView *)blockView finish:(finishBlock)reponse {
    MTWeakSelf;
    MBProgressHUD *hud = nil;
    if (blockView != nil && [blockView isKindOfClass:[UIView class]]) {
        //遮挡
        hud = [MBProgressHUD showHUDAddedTo:blockView animated:YES];
        hud.removeFromSuperViewOnHide = YES;
    }
    
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    NSURLSessionDataTask *task = [self.manager GET:request.path parameters:request.params success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
#pragma clang diagnostic pop
        
        if (blockView != nil && [blockView isKindOfClass:[UIView class]] && hud != nil) {
            //取消遮挡
            [hud hideAnimated:YES];
        }
        
        //与后台通讯成功
        HttpResponse *response = [weakSelf responseWithJson:responseObject];
        reponse(response);
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        
        if (blockView != nil && [blockView isKindOfClass:[UIView class]] && hud != nil) {
            //取消遮挡
            [hud hideAnimated:YES];
        }
        
        //与后台通讯失败 打印日志
        MyLog(@"NetError:[%@]", error);
        HttpResponse *response = [HttpResponse new];
        response.error = error;
        response.emptyResult = YES;
        reponse(response);
    }];
    return task;
}

- (NSURLSessionTask *)post:(HttpRequest *)request blockView:(UIView *)blockView finish:(finishBlock)reponse {
    MTWeakSelf;
    MBProgressHUD *hud = nil;
    if (blockView != nil && [blockView isKindOfClass:[UIView class]]) {
        //遮挡
        hud = [MBProgressHUD showHUDAddedTo:blockView animated:YES];
        hud.removeFromSuperViewOnHide = YES;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    NSURLSessionDataTask *task = [self.manager POST:request.path parameters:request.params success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
#pragma clang diagnostic pop
        
        if (blockView != nil && [blockView isKindOfClass:[UIView class]] && hud != nil) {
            //取消遮挡
            [hud hideAnimated:YES];
        }
        
        //与后台通讯成功
        HttpResponse *response = [weakSelf responseWithJson:responseObject];
        reponse(response);
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        
        if (blockView != nil && [blockView isKindOfClass:[UIView class]] && hud != nil) {
            //取消遮挡
            [hud hideAnimated:YES];
        }
        
        //与后台通讯失败 打印日志
        MyLog(@"NetError:[%@]", error);
        HttpResponse *response = [HttpResponse new];
        response.error = error;
        response.emptyResult = YES;
        reponse(response);
    }];
    return task;
}

- (NSURLSessionTask *)uploadWith:(HttpRequest *)request blockView:(UIView *)blockView finish:(finishBlock)reponse {
    MTWeakSelf;
    MBProgressHUD *hud = nil;
    if (blockView != nil && [blockView isKindOfClass:[UIView class]]) {
        //遮挡
        hud = [MBProgressHUD showHUDAddedTo:blockView animated:YES];
        hud.removeFromSuperViewOnHide = YES;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    NSURLSessionDataTask *task = [self.manager POST:request.path parameters:request.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
#pragma clang diagnostic pop
        NSDictionary *imageDict = request.imageDataAndKey;
        NSArray *keyArray = [imageDict allKeys];
        for (NSString *key in keyArray) {
            NSData *data = (NSData *)[imageDict objectForKey:key];
            [formData appendPartWithFileData:data name:key fileName:[NSString stringWithFormat:@"%@.jpg",key] mimeType:@"jpg"];
        }
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
        
        if (blockView != nil && [blockView isKindOfClass:[UIView class]] && hud != nil) {
            //取消遮挡
            [hud hideAnimated:YES];
        }
        
        //与后台通讯成功
        HttpResponse *response = [weakSelf responseWithJson:responseObject];
        reponse(response);
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){
        
        if (blockView != nil && [blockView isKindOfClass:[UIView class]] && hud != nil) {
            //取消遮挡
            [hud hideAnimated:YES];
        }
        
        //与后台通讯失败
        MyLog(@"NetError:[%@]", error);
        HttpResponse *response = [HttpResponse new];
        response.error = error;
        response.emptyResult = YES;
        reponse(response);
    }];
    return task;
}

#pragma mark - 内部方法
- (HttpResponse *)responseWithJson:(id)responseObj {
    HttpResponse *response = [HttpResponse mj_objectWithKeyValues:responseObj];
    if (!response.success) {
        NSError *error = [NSError errorWithDomain:kHttpClientErrorDomain code:response.success userInfo:@{NSLocalizedDescriptionKey : [response.msg isExist] ? response.msg : @"网络请求失败了，请重试。"}];
        response.error = error;
        response.emptyResult = YES;
    }else{
        id result = responseObj[[HttpClientConfig sharedInstance].contentKey];
        if (result && ![result isKindOfClass:[NSNull class]] && [result isKindOfClass:[NSDictionary class]]) {
            response.body = result;
            response.emptyResult = NO;
        } else {
            response.emptyResult = YES;
        }
        response.error = nil;
    }
    return response;
}


@end
