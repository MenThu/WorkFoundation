//
//  MTPlayer.m
//  MTVideoPlayer
//
//  Created by MenThu on 2016/12/27.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>

typedef enum : NSUInteger {
    MTVideoStatusInitial, //播放器初始化状态，未点击播放，暂停，也没有暂停
    MTVideoStatusNowPlay, //播放器正在播放
    MTVideoStatusPause,//播放器暂停
    MTVideoStatusCommple,//播放完成
} MTVideoStatus;




static NSString * const PlayerItemStatusContext = @"PlayerItemStatusContext"; //视频的缓冲状态
static NSString * const PlayerPreloadObserverContext = @"PlayerPreloadObserverContext"; //视频的缓冲进度
static NSString * const PlayerCMTimeValue = @"CMTimeValue"; //视频的总时间

@interface MTPlayer ()
{
    //播放器
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    AVPlayerLayer *_playerLayer;
    NSString *_videoUrl;
    
    BOOL _isDrag;
    
    //底部工具条
    UIView *_toolView;
    UIButton *_playOrPauseBtn;
    UISlider *_progressSlider;
    UIButton *_fullOrSmallScreenBtn;
    MTVideoStatus _videoStatus;
    CGFloat _totalTime;
    UILabel *_leftCurrentLabel;
    UILabel *_rightTotalLabel;
    UIProgressView *_loadingProgressView;
    id _playbackTimeObserver;//监听播放起状态的监听者
    AVPlayerItemVideoOutput *_videoOutPut;
    CGFloat _drageValue;
    
    
    UIView *_dragView;
    UIImageView *_dragImage;
    UILabel *_dragLeftLabel;
    UILabel *_dragRightLabel;
    
    AVAsset *_playerAsset;
    AVAssetImageGenerator *_imageGenerator;
}


@end

@implementation MTPlayer

- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSString *)url{
    if (self = [super initWithFrame:frame]) {
        _videoUrl = url;
        [self configContentView];
        [self configPlayer];
    }
    return self;
}

//配置界面
- (void)configContentView{
    //    CGFloat temp = 236.f / 255.f;
    self.backgroundColor = [UIColor blackColor];
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    [self addGestureRecognizer:singleTap];
    
    [self configToolView];
}

- (void)singleTap{
    CGFloat alpha = (_toolView.alpha == 1 ? 0 : 1);
    [UIView animateWithDuration:0.5 animations:^{
        _toolView.alpha = alpha;
    }];
}

//底部工具栏
- (void)configToolView{
    //旋转通知
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    _toolView = [[UIView alloc] init];
    [self addSubview:_toolView];
    
    //底部
    //左侧播放暂停按钮
    UIButton *playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playOrPauseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [playOrPauseBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playOrPauseBtn setTitle:@"暂停" forState:UIControlStateSelected];
    [playOrPauseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playOrPauseBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:(_playOrPauseBtn = playOrPauseBtn)];
    
    //进度条
    UIProgressView *loadingProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    loadingProgressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    loadingProgressView.trackTintColor    = [UIColor clearColor];
    [loadingProgressView setProgress:0.0 animated:NO];
    [_toolView addSubview:(_loadingProgressView = loadingProgressView)];
    
    //中间进度条
    UISlider *progressSlider = [[UISlider alloc] init];
    progressSlider = [[UISlider alloc] init];
    progressSlider.backgroundColor = [UIColor clearColor];
    progressSlider.minimumValue = 0.0;
    progressSlider.maximumValue = 1.0;
    [progressSlider setThumbImage:[UIImage imageNamed:@"dot"]  forState:UIControlStateNormal];
    progressSlider.minimumTrackTintColor = [UIColor greenColor];
    progressSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    progressSlider.value = 0.0;//指定初始值
    [progressSlider addTarget:self action:@selector(stratDragSlide:)  forControlEvents:UIControlEventValueChanged];//进度条的拖拽事件
    [progressSlider addTarget:self action:@selector(updateProgressInside:) forControlEvents:UIControlEventTouchUpInside];//进度条的点击事件
    [progressSlider addTarget:self action:@selector(updateProgressInside:) forControlEvents:UIControlEventTouchUpOutside];
    [_toolView addSubview:(_progressSlider = progressSlider)];
    
    //左侧时间按钮
    UILabel *leftCurrentLabel = [[UILabel alloc] init];
    leftCurrentLabel = [[UILabel alloc]init];
    leftCurrentLabel.textAlignment = NSTextAlignmentLeft;
    leftCurrentLabel.textColor = [UIColor whiteColor];
    leftCurrentLabel.backgroundColor = [UIColor clearColor];
    leftCurrentLabel.font = [UIFont systemFontOfSize:11];
    leftCurrentLabel.text = [NSString convertTime:0.0];//设置默认值
    [_toolView addSubview:(_leftCurrentLabel = leftCurrentLabel)];
    
    //右侧总体时间按钮
    UILabel *rightTotalLabel = [[UILabel alloc] init];
    rightTotalLabel = [[UILabel alloc] init];
    rightTotalLabel.textAlignment = NSTextAlignmentRight;
    rightTotalLabel.textColor = [UIColor whiteColor];
    rightTotalLabel.backgroundColor = [UIColor clearColor];
    rightTotalLabel.font = [UIFont systemFontOfSize:11];
    rightTotalLabel.text = [NSString convertTime:0.0];//设置默认值
    [_toolView addSubview:(_rightTotalLabel = rightTotalLabel)];
    
    //右侧全屏按钮
    UIButton *fullOrSmallScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fullOrSmallScreenBtn addTarget:self action:@selector(fullOrSmall:) forControlEvents:UIControlEventTouchUpInside];
    fullOrSmallScreenBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fullOrSmallScreenBtn setTitle:@"全屏" forState:UIControlStateNormal];
    [fullOrSmallScreenBtn setTitle:@"缩小" forState:UIControlStateSelected];
    [fullOrSmallScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_toolView addSubview:(_fullOrSmallScreenBtn = fullOrSmallScreenBtn)];

    //建立约束
    __weak typeof(self) weakSelf = self;
    
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf);
        make.height.mas_equalTo(80);
    }];
    
    [playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.height.equalTo(_toolView);
        make.width.mas_equalTo(65);
    }];
    
    [progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playOrPauseBtn.mas_right);
        make.bottom.height.equalTo(playOrPauseBtn);
    }];
    
    [loadingProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(progressSlider);
        make.height.mas_equalTo(1);
    }];
    
    [leftCurrentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(progressSlider);
        make.width.height.equalTo(rightTotalLabel);
        make.right.equalTo(rightTotalLabel.mas_left);
        make.height.equalTo(progressSlider).multipliedBy(0.4);
    }];
    
    [rightTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(progressSlider);
    }];
    
    [fullOrSmallScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progressSlider.mas_right);
        make.right.bottom.equalTo(_toolView);
        make.width.height.equalTo(playOrPauseBtn);
    }];
    
    
    //拖动时，展示帧图片
    _dragView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    _dragView.backgroundColor = [UIColor blackColor];
    _dragView.hidden = YES;
    [self addSubview:_dragView];
    
    _dragImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_dragView.frame), 120)];
    _dragImage.contentMode = UIViewContentModeScaleAspectFill;
    _dragImage.clipsToBounds = YES;
    [_dragView addSubview:_dragImage];
    
    _dragLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_dragImage.frame), CGRectGetWidth(_dragView.frame)/2, CGRectGetHeight(_dragView.frame) - CGRectGetHeight(_dragImage.frame))];
    _dragLeftLabel.font = [UIFont systemFontOfSize:13];
    _dragLeftLabel.textAlignment = NSTextAlignmentLeft;
    _dragLeftLabel.textColor = [UIColor whiteColor];
    _dragLeftLabel.backgroundColor = [UIColor clearColor];
    [_dragView addSubview:_dragLeftLabel];
    
    
    _dragRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_dragLeftLabel.frame), CGRectGetHeight(_dragImage.frame), CGRectGetWidth(_dragView.frame)/2, CGRectGetHeight(_dragView.frame) - CGRectGetHeight(_dragImage.frame))];
    _dragRightLabel.font = [UIFont systemFontOfSize:13];
    _dragRightLabel.textAlignment = NSTextAlignmentRight;
    _dragRightLabel.textColor = [UIColor whiteColor];
    _dragRightLabel.backgroundColor = [UIColor clearColor];
    [_dragView addSubview:_dragRightLabel];
}

//配置AVPlayer
- (void)configPlayer{
    //拖动的记录值
    _drageValue = 0.f;
    
    _videoStatus = MTVideoStatusInitial;
    //设置player的参数
    
    
    NSURL *url = [NSURL URLWithString:_videoUrl];
    _playerItem = [AVPlayerItem playerItemWithURL:url];
    
    //用来获取视频是否可以缓存
    [_playerItem addObserver:self forKeyPath:@"status" options:0 context:(__bridge void * _Nullable)(PlayerItemStatusContext)];
    
    //用来更新缓冲进度条
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:(__bridge void * _Nullable)(PlayerPreloadObserverContext)];
    
    //用来获取视频的时间长度
    [_playerItem addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)PlayerCMTimeValue];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _player.usesExternalPlaybackWhileExternalScreenIsActive=YES;
    //AVPlayerLayer
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    
    //WMPlayer视频的填充模式
    //    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer insertSublayer:_playerLayer atIndex:0];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //播放器总是跟MTPlayer的Bounds等大
    NSLog(@"MTPlayerLayout:[%@]",NSStringFromCGRect(self.bounds));
    _playerLayer.frame = self.bounds;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (context ==  (__bridge void * _Nullable)(PlayerItemStatusContext)) {
        if ([keyPath isEqualToString:@"status"]) {
            if (_playerItem.status == AVPlayerItemStatusUnknown) {
                NSLog(@"初始化状态");
            }else if (_playerItem.status == AVPlayerItemStatusReadyToPlay) { //准备好播放
                NSLog(@"缓冲成功");
                //开启定时器 每个一秒更新底部进度条的圆球
                __weak typeof(self) weakSelf = self;
                _playbackTimeObserver =  [_player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC)  queue:dispatch_get_main_queue() /* If you pass NULL, the main queue is used. */
                                                                          usingBlock:^(CMTime time){
                                                                              [weakSelf updateBottomSliderTimeValue];
                                                                          }];
            }else if (_playerItem.status == AVPlayerItemStatusFailed){ //失败
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
            _totalTime = (CGFloat)CMTimeGetSeconds(_playerItem.duration);
            _progressSlider.maximumValue = _totalTime;
            NSLog(@"总时长:[%f]", _totalTime);
            _rightTotalLabel.text = [NSString convertTime:_totalTime];
        }
    }
}

//播放的时候每秒更新底部进度条
- (void)updateBottomSliderTimeValue{
    CGFloat nowTime = _playerItem.currentTime.value / _playerItem.currentTime.timescale;
    //更改左侧Label显示
    _leftCurrentLabel.text = [NSString convertTime:nowTime];
    //更改底部进度条显示
    CGFloat value = nowTime;
    if (!_isDrag) {
        [_progressSlider setValue:value];
    }
}

- (void)updateLoadedTimeRanges:(NSArray *)timeRanges {
    if (timeRanges && [timeRanges count]) {
        NSArray *loadedTimeRanges = [_playerItem loadedTimeRanges];
        CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        float startSeconds        = CMTimeGetSeconds(timeRange.start);
        float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
        float timeInterval = startSeconds + durationSeconds;
        CGFloat totalTime = CMTimeGetSeconds(_playerItem.duration);
        NSLog(@"%f %f %f", startSeconds, durationSeconds,totalTime);
        [_loadingProgressView setProgress:timeInterval / totalTime animated:NO];
    }
}

#pragma mark - AVPlayer播放暂停
- (void)startPlay{
    if (_playerItem.status == AVPlayerItemStatusReadyToPlay) {
        //资源已经可以播放
        if (_videoStatus != MTVideoStatusNowPlay) {
            [_player play];
            _videoStatus = MTVideoStatusNowPlay;
        }
    }
}

- (void)pause{
    if (_videoStatus != MTVideoStatusPause) {
        [_player pause];
        _videoStatus = MTVideoStatusPause;
    }
}

- (void)playBtnClick:(UIButton *)playBtn{
    if (playBtn.selected == YES) {
        //暂停
        [_player pause];
        _videoStatus = MTVideoStatusPause;
    }else{
        [_player play];
        _videoStatus = MTVideoStatusNowPlay;
    }
    playBtn.selected = !playBtn.selected;
}

#pragma mark - UISlider代理
- (void)stratDragSlide:(UISlider *)slider{
    
    
    _leftCurrentLabel.text = [NSString convertTime:slider.value];
    
//    if (_drageValue == 0.f) {
//        _dragView.hidden = NO;
//        _drageValue = slider.value;
//    }
//    _isDrag = YES;
//    //获取视频的当前帧
//    _dragView.frame = CGRectMake((slider.value/slider.maximumValue)*slider.frame.size.width + slider.frame.origin.x-CGRectGetWidth(_dragView.frame)/2, _toolView.frame.origin.y-5-CGRectGetHeight(_dragView.frame), _dragView.frame.size.width, _dragView.frame.size.height);
//    _dragLeftLabel.text = [NSString stringWithFormat:@"%@/%@",[NSString convertTime:slider.value],_rightTotalLabel.text];
//    CGFloat value = slider.value - _drageValue;
//    NSString *rightLabelText = @"";
//    if (value >= 0) {
//        rightLabelText = [NSString stringWithFormat:@"+%d秒", (int)value];
//    }else{
//        rightLabelText = [NSString stringWithFormat:@"%d秒", (int)value];
//    }
//    _dragRightLabel.text = rightLabelText;
}

- (void)updateProgressInside:(UISlider *)slider{
    _leftCurrentLabel.text = [NSString convertTime:slider.value];
    [_player seekToTime:CMTimeMakeWithSeconds(slider.value, _playerItem.currentTime.timescale)];
    _drageValue = 0.f;
    _dragView.hidden = YES;
    _isDrag = NO;
}

- (UIImage*)getCurrentImage
{
    CMTime itemTime = _player.currentItem.currentTime;
    CVPixelBufferRef pixelBuffer = [_videoOutPut copyPixelBufferForItemTime:itemTime itemTimeForDisplay:nil];
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pixelBuffer),
                                                 CVPixelBufferGetHeight(pixelBuffer))];
    
    //当前帧的画面
    UIImage *currentImage = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    return currentImage;
}

#pragma mark - 屏幕旋转
-(void)onDeviceOrientationChange
{
    if (!self.orientaionBlock) {
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait: //home button on the bottom
        {
            self.orientaionBlock(0);
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown: //home button on the top
        {
            //不处理
        }
            break;
        case UIDeviceOrientationLandscapeLeft: //home button on the right
        {
            self.orientaionBlock(1);
        }
            break;
        case UIDeviceOrientationLandscapeRight: //home button on the left
        {
            self.orientaionBlock(1);
        }
            break;
            
        default:
            break;
    }
}

- (void)fullOrSmall:(UIButton *)fullOrSmall{
    if (!self.orientaionBlock) {
        return;
    }
    NSNumber *value = nil;
    if (fullOrSmall.selected) {
        //正常显示
        value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    }else{
        //全屏显示
        value = [NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft];
    }
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    fullOrSmall.selected = !fullOrSmall.selected;
}

@end
