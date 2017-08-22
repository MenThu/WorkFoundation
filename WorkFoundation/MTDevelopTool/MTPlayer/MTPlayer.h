//
//  MTPlayer.h
//  Test
//
//  Created by MenThu on 2017/8/15.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTPlayerModel.h"
#import "MTControllerView.h"

// 播放器的几种状态
typedef NS_ENUM(NSInteger, MTPlayerState) {
    MTPlayerStateFailed,     // 播放失败
    MTPlayerStateBuffering,  // 缓冲中
    MTPlayerStatePlaying,    // 播放中
    MTPlayerStateStopped,    // 停止播放
    MTPlayerStatePause,       // 暂停播放
    MTPlayerStateFinish       // 完成播放
};

@interface MTPlayer <VIEW : MTControllerView *> : UIView

kSingletonH

/**
 *  controllerView，MTPlayer的控制层
 *  playModel，播放器的属性
 **/
- (void)playWithControllerView:(VIEW)controllerView playModel:(MTPlayerModel *)model;

/**
 *  播放器使用MTControllerView和MTPlayerModel来初始化播放器
 **/
- (void)playWithMtControllerView:(MTPlayerModel *)model;

/**
 *  播放
 **/
- (void)play;

/**
 *  暂停
 **/
- (void)pause;

@end
