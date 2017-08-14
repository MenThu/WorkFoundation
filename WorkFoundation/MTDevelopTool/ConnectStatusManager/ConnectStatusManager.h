//
//  ConnectStatusManager.h
//  TestCocoapod
//
//  Created by MenThu on 16/9/22.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"


typedef enum : NSUInteger {
    WifiStatus,
    WWANStatus,
    UnknownStatus,
    NotReachableStatus
} ConnectStatus;





@interface ConnectStatusManager : NSObject

kSingletonH

typedef void(^ChangeBlock)(ConnectStatus status);

@property (nonatomic, copy) ChangeBlock statusChangeBlock;

@end
