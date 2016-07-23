//
//  NSObject+HttpRequest.h
//  TestGitHub
//
//  Created by MenThu on 16/7/21.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpLibrary.h"

@interface NSObject (HttpRequest)

+ (void)requestServerWith:(HttpRequest *)request successReturn:(finishBlock)success  isShowProgress:(BOOL)isShow;

@end
