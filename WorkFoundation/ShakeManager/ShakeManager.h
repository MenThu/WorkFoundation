//
//  ShakeManager.h
//  TestCocoapod
//
//  Created by MenThu on 16/9/1.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef enum : NSUInteger {
    
    ShakeOnly,//只有震动
    
    SoundOnly//只有声音
    
} ShakeType;


@interface ShakeManager : NSObject

kSingletonH


@property (nonatomic, copy) NSString *soundUrl;
@property (nonatomic, assign) ShakeType shakeType;


- (void)playShake;

- (void)stopShake;


@end
