//
//  MTPlayer.m
//  MTVideoPlayer
//
//  Created by MenThu on 2016/12/27.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseAVPlayer.h"
#import "MTSlider.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
#import "AVAsset+Work.h"

typedef enum : NSUInteger {
    MTVideoStatusInitial, //播放器初始化状态，未点击播放，暂停，也没有暂停
    MTVideoStatusNowPlay, //播放器正在播放
    MTVideoStatusPause,//播放器暂停
    MTVideoStatusCommple,//播放完成
} MTVideoStatus;

static NSString * const PlayerItemStatusContext = @"PlayerItemStatusContext"; //视频的缓冲状态
static NSString * const PlayerPreloadObserverContext = @"PlayerPreloadObserverContext"; //视频的缓冲进度
static NSString * const PlayerCMTimeValue = @"CMTimeValue"; //视频的总时间



@interface MTBaseAVPlayer ()
{
    //外界是否已经调用了startPlay
    BOOL _isPlayerSet;
    
    //视频是否已经播放完成
    BOOL _isPlayerFinish;
    
    //播放器的当前状态
    MTVideoStatus _avPlayerStatus;
    
    MTTimer *_progressTimer;
}

//AVPlayer的相关属性
@property (nonatomic, strong, readwrite) AVPlayer *avPlayer;
@property (nonatomic, strong, readwrite) AVPlayerItem *avPlayerItem;
@property (nonatomic, strong, readwrite) AVPlayerLayer *avPlayerLayer;
@property (nonatomic, assign, readwrite) CGSize videoSize;

//获取输出流的地址
@property(nonatomic, strong) AVPlayerItemVideoOutput * videoOutPut;

//监听播放起状态的监听者
@property (nonatomic, strong) id playbackTimeObserver;

//用来获取视频文件的尺寸
@property (nonatomic, strong)AVAsset *videoAsset;

@end

@implementation MTBaseAVPlayer

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initVaribles];
        [self configContentView];
    }
    return self;
}

//配置界面
- (void)configContentView{
    _isPlayerSet = _isPlayerFinish = NO;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor blackColor];
    _avPlayerStatus = MTVideoStatusInitial;
}

#pragma mark - setter,getter
- (void)setVideoUrl:(NSString *)videoUrl{
    _videoUrl = videoUrl;
    [self configPlayer];
}

/**
 #pragma mark - 解析视频尺寸
 - (void)analysisVideoSize{
 MTWeakSelf;
 AVAsset *videoAsset = [AVAsset assetWithURL:[NSURL URLWithString:self.videoUrl]];
 self.videoAsset = videoAsset;
 [self.videoAsset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
 dispatch_async(dispatch_get_main_queue(), ^{
 AVAsset *videoAsset = weakSelf.videoAsset;
 if (videoAsset.playable) {
 [weakSelf loadedResourceForPlay];
 }
 });
 }];
 }
 
 - (void)loadedResourceForPlay{
 NSArray *array = self.videoAsset.tracks;
 self.videoSize = CGSizeZero;
 for (AVAssetTrack *track in array) {
 if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
 self.videoSize = track.naturalSize;
 
 }
 }
 if (self.videoAssetSize) {
 self.videoAssetSize(self.videoSize);
 }
 }
 **/

- (void)initVaribles{
    self.timeInterval = 1.f;
    self.intervalBlock = nil;
    self.totalTimeBlock = nil;
    self.bufferBlock = nil;
    self.playerFinsh = nil;
}

//配置AVPlayer
- (void)configPlayer{
    [self closePlayer];
    
    _avPlayerStatus = MTVideoStatusInitial;
    //设置player的参数
    NSURL *url = [NSURL URLWithString:_videoUrl];
    self.avPlayerItem = [AVPlayerItem playerItemWithURL:url];
//    self.avPlayerItem = [AVPlayerItem playerItemWithAsset:self.videoAsset];
    
    //用来获取视频是否可以缓存
    [self.avPlayerItem addObserver:self forKeyPath:@"status" options:0 context:(__bridge void * _Nullable)(PlayerItemStatusContext)];
    
    //用来更新缓冲进度条
    [self.avPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:(__bridge void * _Nullable)(PlayerPreloadObserverContext)];
    
    //用来获取视频的时间长度
    [self.avPlayerItem addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)PlayerCMTimeValue];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
    self.avPlayer.usesExternalPlaybackWhileExternalScreenIsActive=YES;
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.avPlayerLayer.frame = self.frame;
    //Player视频的填充模式   AVLayerVideoGravityResizeAspect  AVLayerVideoGravityResizeAspectFill AVLayerVideoGravityResize
    self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer insertSublayer:self.avPlayerLayer atIndex:0];
    
    [self addNotification];
    [self prepareTimer];
}

- (void)prepareTimer{
    MTWeakSelf;
    MTTimerInfo *timerInfo = [MTTimerInfo new];
    timerInfo.timeInterval = 0.05f;
    timerInfo.countBlock = ^(CGFloat count){
        NSInteger currentTime = (NSInteger)CMTimeGetSeconds([weakSelf.avPlayerItem currentTime]);
        if (weakSelf.intervalBlock) {
            weakSelf.intervalBlock(currentTime);
        }
    };
    self->_progressTimer = [MTTimer createWith:timerInfo];
}

#pragma mark - 添加通知
- (void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayer.currentItem];
}

//视频播放完成
-(void)playbackFinished:(NSNotification *)notification{
    //视频播放完成，初始化界面
    _isPlayerFinish = YES;
    _avPlayerStatus = MTVideoStatusInitial;
    [self->_progressTimer pauseTimer];
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(0, self.avPlayerItem.currentTime.timescale)];
    if (self.playerFinsh) {
        self.playerFinsh();
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (context ==  (__bridge void * _Nullable)(PlayerItemStatusContext)) {
        if ([keyPath isEqualToString:@"status"]) {
            if (self.avPlayerItem.status == AVPlayerItemStatusUnknown) {
                NSLog(@"初始化状态");
            }else if (self.avPlayerItem.status == AVPlayerItemStatusReadyToPlay) { //准备好播放
                NSLog(@"缓冲成功");
                if (_isPlayerSet) {
                    //在视频未缓冲成功之前已经调用了startPlay
                    [self startPlay];
                }
                /**
                 if (self.intervalBlock) {
                 //开启定时器,获取播放器进度
                 MTWeakSelf;
                 self.playbackTimeObserver =  [self.avPlayer
                 addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(self.timeInterval, NSEC_PER_SEC)
                 queue:dispatch_get_main_queue()
                 usingBlock:^(CMTime time){
                 if (weakSelf.intervalBlock) {
                 CGFloat currentTime =
                 weakSelf.avPlayerItem.currentTime.value
                 /
                 weakSelf.avPlayerItem.currentTime.timescale;
                 weakSelf.intervalBlock(currentTime);
                 }
                 }];
                 }
                 **/
            }else if (self.avPlayerItem.status == AVPlayerItemStatusFailed){ //失败
                NSLog(@"缓冲失败");
            }
        }
    }else if (context == (__bridge void * _Nullable)(PlayerPreloadObserverContext)){
        if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            NSArray *timeRanges = (NSArray *)[change objectForKey:NSKeyValueChangeNewKey];
            //获取缓存的进度条
            [self updateLoadedTimeRanges:timeRanges];
        }
    }else if (context == (__bridge void * _Nullable)(PlayerCMTimeValue)){
        if ([keyPath isEqualToString:@"duration"]) {
            CGFloat videoTotalTime = (CGFloat)CMTimeGetSeconds(self.avPlayerItem.duration);
            if (self.totalTimeBlock) {
                self.totalTimeBlock(videoTotalTime);
            }
        }
    }
}

//获取视频的缓冲进度
- (void)updateLoadedTimeRanges:(NSArray *)timeRanges {
    if (timeRanges && [timeRanges count]) {
        NSArray *loadedTimeRanges = [self.avPlayerItem loadedTimeRanges];
        //获取缓冲区域
        CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];
        float startSeconds        = CMTimeGetSeconds(timeRange.start);
        float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
        float timeInterval = startSeconds + durationSeconds;
        CGFloat totalTime = CMTimeGetSeconds(self.avPlayerItem.duration);
        if (self.bufferBlock) {
            self.bufferBlock(timeInterval/totalTime);
        }
    }
}

#pragma mark - AVPlayer播放，暂停，销毁
- (void)startPlay{
    if (self.avPlayerItem.status == AVPlayerItemStatusReadyToPlay) {
        //资源已经可以播放
        if (_avPlayerStatus != MTVideoStatusNowPlay) {
            [self.avPlayer play];
            _avPlayerStatus = MTVideoStatusNowPlay;
            [self->_progressTimer startTimer];
        }
    }else{
        _isPlayerSet = YES;
    }
}

- (void)pause{
    if (_avPlayerStatus != MTVideoStatusPause) {
        [self.avPlayer pause];
        _avPlayerStatus = MTVideoStatusPause;
        [self->_progressTimer pauseTimer];
    }
}

- (void)closePlayer{
    @try {
        //移除通知
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    @catch (NSException *exception) {
        NSLog(@"多次删除了");
    }
    
    
    if (self.avPlayer) {
        [self.avPlayer pause];
        self.avPlayer = nil;
    }
    
    if (self.avPlayerItem) {
        [self.avPlayerItem removeObserver:self forKeyPath:@"status"];
        [self.avPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self.avPlayerItem removeObserver:self forKeyPath:@"duration"];
        self.avPlayerItem = nil;
    }
    
    if (self.avPlayerLayer.superlayer) {
        [self.avPlayerLayer removeFromSuperlayer];
        self.avPlayerLayer = nil;
    }
    
    
    [self->_progressTimer endTimer];
    self->_progressTimer = nil;
}

- (void)dealloc{
    [self closePlayer];
}

@end
