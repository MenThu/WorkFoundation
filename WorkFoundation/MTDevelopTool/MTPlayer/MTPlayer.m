//
//  MTPlayer.m
//  Test
//
//  Created by MenThu on 2017/8/15.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import "MTPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface MTPlayer ()

/** 播放器属性 */
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

/** 媒体信息 */
@property (nonatomic, strong) MTPlayerModel *playerModel;
@property (nonatomic, strong) NSURL *videoUrl;

/** 播放状态 */
@property (nonatomic, assign) MTPlayerState playerStatus;

/** 缓冲完成后自动播放 */
@property (nonatomic, assign) BOOL autoPlay;

/** 控制器视图 */
@property (nonatomic, strong) MTControllerView *controllerView;

/** 定时器 */
@property (nonatomic, strong) MTTimer *playerTimer;

@end

@implementation MTPlayer

kSingletonM

- (instancetype)init{
    if (self = [super init]) {
        [self configInfo];
    }
    return self;
}

/**
 *  配置界面
 **/
- (void)configInfo{
    MTWeakSelf;
    self.backgroundColor = [UIColor blackColor];
    self.playerStatus = MTPlayerStateStopped;
    MTTimerInfo *timerInfo = [MTTimerInfo new];
    timerInfo.timeInterval = 0.5;
    timerInfo.countBlock = ^(CGFloat count) {
        [weakSelf checkCurrentTimeOfPlayerItem];
    };
    self.playerTimer = [MTTimer createWith:timerInfo];
}



/**
 *  检测当前播放时间
 **/
- (void)checkCurrentTimeOfPlayerItem{
    AVPlayerItem *currentItem = self.playerItem;
    NSArray *loadedRanges = currentItem.seekableTimeRanges;
    if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
        NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
        CGFloat totalTime     = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
        CGFloat playValue         = currentTime / totalTime;
        self.controllerView.currentTime = currentTime;
        self.controllerView.playValue = playValue;
    }
}

- (void)playWithMtControllerView:(MTPlayerModel *)model{
    MTControllerView *controllerView = [[MTControllerView alloc] init];
    [self playWithControllerView:controllerView playModel:model];
}

/**
 *  设置播放的参数
 **/
- (void)playWithControllerView:(MTControllerView *)controllerView playModel:(MTPlayerModel *)model{
    if ([controllerView isKindOfClass:[MTControllerView class]]) {
        self.controllerView = controllerView;
        [self addSubview:controllerView];
    }
    self.playerModel = model;
    self.videoUrl = [NSURL URLWithString:model.videoString];
    [self configMTPlayer];
}

/**
 *  播放
 **/
- (void)play{
    if (self.playerStatus != MTPlayerStatePlaying) {
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            [self.player play];
            self.playerStatus = MTPlayerStatePlaying;
            self.autoPlay = NO;
            [self.playerTimer startTimer];
            return;
        }
    }
    self.autoPlay = YES;
}

/**
 *  暂停
 **/
- (void)pause{
    if (self.playerStatus != MTPlayerStatePause) {
        [self.player pause];
        [self.playerTimer pauseTimer];
        self.playerStatus = MTPlayerStatePause;
    }
}

/**
 *  配置MTPlayer属性
 **/
- (void)configMTPlayer{
    [self closeMTPlayer];
    self.playerItem = [AVPlayerItem playerItemWithURL:self.videoUrl];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
}

/**
 *  销毁MTPlayer
 **/
- (void)closeMTPlayer{
    self.autoPlay = NO;
    [self.playerTimer pauseTimer];
}

/**
 *  视频播放完成
 **/
- (void)moviePlayDidEnd:(NSNotification *)notification{
    
}

/**
 *  playItem的status属性已经缓冲完成
 **/
- (void)ready2Play{
    // 添加playerLayer到self.layer
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    //可以播放了
    [self setNeedsLayout];
    [self layoutIfNeeded];
    if (self.autoPlay) {
        [self play];
    }
}

#pragma mark - getter,setter
- (void)setPlayerItem:(AVPlayerItem *)playerItem{
    if (![playerItem isKindOfClass:[AVPlayerItem class]]) {
        return;
    }
    if (_playerItem == playerItem) {
        return;
    }
    if (_playerItem) {
        //播放完成的通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    //用来获取视频是否可以播放
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //用来更新缓冲进度条
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //获取视频的总时长
    [playerItem addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区空了，需要等待数据
    [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区有足够数据可以播放了
    [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    _playerItem = playerItem;
}

- (void)setPlayerLayer:(AVPlayerLayer *)playerLayer{
    if (![playerLayer isKindOfClass:[AVPlayerLayer class]]) {
        return;
    }
    if (_playerLayer == playerLayer) {
        return;
    }
    [_playerLayer removeFromSuperlayer];
    _playerLayer = playerLayer;
}

- (void)setControllerView:(MTControllerView *)controllerView{
    if (controllerView == nil) {
        return;
    }
    if (_controllerView == controllerView) {
        return;
    }
    if (_controllerView) {
        [_controllerView removeFromSuperview];
    }
    _controllerView = controllerView;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object == self.player.currentItem) {
        if ([keyPath isEqualToString:@"status"]) {
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                [self ready2Play];
            }
        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
            // 计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration             = self.playerItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            self.controllerView.progress = timeInterval / totalDuration;
        }else if ([keyPath isEqualToString:@"duration"]){
            CGFloat totalTime = (CGFloat)CMTimeGetSeconds(self.playerItem.duration);
            self.controllerView.totalTime = totalTime;
        }
    }
}

/**
 *  计算缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    self.controllerView.frame = self.bounds;
}

#pragma mark - delloc
- (void)dealloc{
    [self.playerTimer endTimer];
    self.playerTimer = nil;
}

@end
