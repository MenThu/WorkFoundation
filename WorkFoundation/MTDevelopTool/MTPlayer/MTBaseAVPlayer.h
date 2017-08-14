//
//  MTPlayer.h
//  MTVideoPlayer
//
//  Created by MenThu on 2016/12/27.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MTBaseAVPlayer : UIView

//AVPlayer的相关属性
@property (nonatomic, strong, readonly) AVPlayer *avPlayer;
@property (nonatomic, strong, readonly) AVPlayerItem *avPlayerItem;
@property (nonatomic, strong, readonly) AVPlayerLayer *avPlayerLayer;

/**
    获取到视频资源的尺寸时，回调此block块，可以为nil
 **/
@property (nonatomic, copy) void (^videoAssetSize) (CGSize videoSize);
@property (nonatomic, readonly) CGSize videoSize;

/**
    视频链接[全路径]
 **/
@property (nonatomic, copy) NSString *videoUrl;

/**
    调用block的间隔 [默认一秒]
 **/
@property (nonatomic, assign) CGFloat timeInterval;

/**
    当前播放时间的进度，可以为nil
 **/
@property (nonatomic, copy) void (^intervalBlock) (CGFloat currentTime);

/**
    获取视频总时长，可以为nil
 **/
@property (nonatomic, copy) void (^totalTimeBlock) (CGFloat totalTime);

/**
    获取视频缓冲进度，可以为nil
 **/
@property (nonatomic, copy) void (^bufferBlock) (CGFloat bufferSchedule);

/**
    播放完完成播放，可以为nil
 **/
@property (nonatomic, copy) void (^playerFinsh) (void);

/**
    变量初始化
 **/
- (void)initVaribles;

/**
    配置界面，子类需要Call [super configContentView]
 **/
- (void)configContentView;

/**
    开始播放
 **/
- (void)startPlay;

/**
    暂停
 **/
- (void)pause;

/**
    关闭视频
 **/
- (void)closePlayer;

@end
