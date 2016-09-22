//
//  ConnectStatusManager.m
//  TestCocoapod
//
//  Created by MenThu on 16/9/22.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "ConnectStatusManager.h"
#import "AFNetWorking.h"

@interface ConnectStatusManager ()

@property (nonatomic, strong) AFNetworkReachabilityManager *reachManager;


@end


@implementation ConnectStatusManager


kSingletonM


- (instancetype)init
{
    __weak typeof(self) weakSelf = self;
    if (self = [super init]) {
        self.reachManager = [AFNetworkReachabilityManager sharedManager];
        [self.reachManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            /*
             AFNetworkReachabilityStatusUnknown          = -1,
             AFNetworkReachabilityStatusNotReachable     = 0,
             AFNetworkReachabilityStatusReachableViaWWAN = 1,
             AFNetworkReachabilityStatusReachableViaWiFi = 2,
             */
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    [weakSelf changeAct:UnknownStatus];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    [weakSelf changeAct:NotReachableStatus];
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    [weakSelf changeAct:WWANStatus];
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [weakSelf changeAct:WifiStatus];
                    break;
                default:
                    break;
            }
        }];
    }
    return self;
}

- (void)setStatusChangeBlock:(ChangeBlock)statusChangeBlock
{
    _statusChangeBlock = statusChangeBlock;
    [self.reachManager startMonitoring];
}

- (void)changeAct:(ConnectStatus)status
{
    if (self.statusChangeBlock) {
        self.statusChangeBlock(status);
    }
}

@end
