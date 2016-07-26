//
//  HttpClient.m
//  TestGitHub
//
//  Created by MenThu on 16/7/20.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "HttpClient.h"
#import "HttpClientConfig.h"
#import "YYKit.h"
#import "NSString+isExist.h"



NSString *const kHttpClientErrorDomain = @"com.MenThu.errorDomain";

static HttpClient *_httpClient = nil;

@interface HttpClient ()

@property (nonatomic, strong, readwrite) AFHTTPSessionManager *manager;

@end


@implementation HttpClient

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _httpClient = [[HttpClient alloc] init];
    });
    return _httpClient;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = [HttpClientConfig sharedInstance].timeout;
        _manager= [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[HttpClientConfig sharedInstance].baseURLString] sessionConfiguration:configuration];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"MenThu" ofType:@"cer"];//证书的路径
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSArray alloc] initWithObjects:certData, nil]];
        _manager.securityPolicy.allowInvalidCertificates = YES;
        [_manager.securityPolicy setValidatesDomainName:NO];
    }
    return self;
}

- (NSURLSessionTask *)post:(HttpRequest *)request finish:(finishBlock)reponse fail:(finishBlock)failBlock error:(finishBlock)errorBlock isShowProgress:(BOOL)isShow
{
    
    
    
    
    
//    NSLog(@"path : %@, params : %@", request.path, request.params);
    @weakify(self);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    NSURLSessionDataTask *task = [self.manager POST:request.path parameters:request.params success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
#pragma clang diagnostic pop
        
        @strongify(self);
        HttpResponse *fromServer = [self responseWithJson:responseObject];
        if (fromServer.status != [HttpClientConfig sharedInstance].successStatus) {
            failBlock(fromServer);
        }else{
            reponse(fromServer);
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        HttpResponse *response = [HttpResponse new];
        response.error = error;
        if (error.userInfo && [error.userInfo isKindOfClass:[NSDictionary class]]) {
            response.msg = [NSString stringWithFormat:@"%@",error.userInfo];
        }else{
            response.msg = @"AFNetWorking层错误";
        }
        errorBlock(response);
    }];
    return task;
}

- (HttpResponse *)responseWithJson:(id)responseObj {
    
    HttpResponse *response = [HttpResponse mj_objectWithKeyValues:responseObj];
    if (response.status != [HttpClientConfig sharedInstance].successStatus) {
        NSError *error = [NSError errorWithDomain:kHttpClientErrorDomain code:response.status userInfo:@{NSLocalizedDescriptionKey : [response.msg isExist] ? response.msg : @"出现未知错误了，请重试。"}];
        response.error = error;
        return response;
    }
    
    id result = nil;
    NSString *keyString = [HttpClientConfig sharedInstance].returnContentKey;
    if ([keyString isExist]) {
        result = responseObj[keyString];
    }else{
        result = responseObj[@"success_response"];
    }
    
    if (result && ![result isKindOfClass:[NSNull class]]) {
        response.rawResult = result;
        response.emptyResult = NO;
    }else{
        response.emptyResult = YES;
    }
    return response;
}

@end
