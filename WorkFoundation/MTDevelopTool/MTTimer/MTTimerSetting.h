//
//  MTTimerSetting.h
//  test
//
//  Created by MenThu on 17/6/2.
//  Copyright © 2017年 darcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MTTimerSetting : NSObject

/**
 *  调用的时间间隔
 *  默认1秒
 **/
@property (nonatomic, assign) CGFloat timeInterval;

/**
 *  开始时是否立即开启
 *  默认yes
 **/
@property (nonatomic, assign) BOOL isInstantStart;

@end
