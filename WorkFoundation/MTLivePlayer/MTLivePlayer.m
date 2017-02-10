//
//  MTLivePlayer.m
//  LiveDepProject
//
//  Created by MenThu on 2017/2/10.
//  Copyright © 2017年 官辉. All rights reserved.
//

#import "MTLivePlayer.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface MTLivePlayer ()
{
    UIView *_livePlayerView;
    UIImageView *_placeHoldImage;
    NSString *_imageUrlStr;
    NSString *_liveUrlStr;
}

@property (nonatomic, strong) IJKFFMoviePlayerController *player;
@property (nonatomic, weak) UIView *controllerView;
@property (nonatomic, strong) NSURL *liveUrl;

/**
 用来构造视图的block
 **/
@property (nonatomic, copy) void (^customView) (UIView *contentView);

@end

@implementation MTLivePlayer

#pragma mark - 公开方法
- (instancetype)initWithView:(UIView *)controllerView liveUrlStr:(NSString *)liveUrlString placeHoldImage:(NSString *)imageUrlStr toolBlcok:(void (^) (UIView *contentView))customViewBlock{
    if (self = [super init]) {
        self.controllerView = controllerView;
        _liveUrlStr = liveUrlString;
        _imageUrlStr = imageUrlStr;
        self.customView = customViewBlock;

        //1.创建容器视图,建立ijk播放器
        [self initContentForPlay];
        
        //2.创建模糊视图遮挡
        [self setupLoadingView];
        
        //3.状态监听
        [self addNotification];
        
        if (self.customView) {
            self.customView(self.contentView);
        }
    }
    return self;
}

- (void)startPlay{
    if (![self.player isPlaying]) {
        [self.player prepareToPlay];
    }
}

- (void)resumeOrPause:(BOOL)isResume{
    if (isResume) {
        if (![self.player isPlaying]) {
            [self.player play];
        }
    }else{
        if ([self.player isPlaying]) {
            [self.player pause];
        }
    }
}

- (void)stopPlay{
    // 停播
//    [self.player pause];
//    [self.player stop];
    [self.player shutdown];
    //移除视图
    [self.contentView removeFromSuperview];
    [_livePlayerView removeFromSuperview];
    [_placeHoldImage removeFromSuperview];
    
    self.contentView = nil;
    _livePlayerView = nil;
    _placeHoldImage = nil;
    self.player = nil;
    
    [self removeNotification];
}

#pragma mark - 内部方法
- (void)initContentForPlay {
    UIView *contentView = [[UIView alloc] initWithFrame:self.controllerView.bounds];
    self.contentView = contentView;
    [self.controllerView addSubview:self.contentView];
    
    //获取url
    self.liveUrl = [NSURL URLWithString:_liveUrlStr];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.liveUrl withOptions:nil];
    UIView *playerview = [self.player view];
    _livePlayerView = playerview;
    
    //调整自己的宽度和高度
    playerview.frame = self.contentView.bounds;
    playerview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:playerview];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
}

- (void)setupLoadingView
{
    _placeHoldImage = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    _placeHoldImage.contentMode = UIViewContentModeScaleAspectFit;
    _placeHoldImage.clipsToBounds = YES;
    [_placeHoldImage sd_setImageWithURL:[NSURL URLWithString:_imageUrlStr] placeholderImage:[UIImage imageWithColor:MTRandomColor]];
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = _placeHoldImage.bounds;
    [_placeHoldImage addSubview:visualEffectView];
    [self.contentView addSubview:_placeHoldImage];
}

#pragma mark - 通知
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    _placeHoldImage.hidden = YES;
    switch (_player.playbackState) {
            
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

- (void)dealloc{
    NSLog(@"[%@] die", NSStringFromClass([self class]));
}

@end
