//
//  MTControllerView.m
//  Test
//
//  Created by MenThu on 2017/8/15.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import "MTControllerView.h"

#define MTPlayerImage(file) [@"MTPlayer.bundle" stringByAppendingPathComponent:file]

@interface MTControllerView ()

/** 顶部视图和底部视图高度 */
@property (nonatomic, assign) CGFloat viewHeight;

/** 顶部工具条 */
@property (nonatomic, strong) UIView *topView;

/** 退出按钮 */
@property (nonatomic, strong) UIButton *quitBtn;

/** 视频名称 */
@property (nonatomic, strong) UILabel *videoName;

/** 底部工具条 */
@property (nonatomic, strong) UIView *bottomView;

/** 播放/暂停 */
@property (nonatomic, strong) UIButton *playOrPauseBtn;

/** 当前播放时间 */
@property (nonatomic, strong) UILabel *currentTimeLabel;

/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

/** 观看进度条 */
@property (nonatomic, strong) UISlider *videoSlider;

/** 视频总时长 */
@property (nonatomic, strong) UILabel *totalTimeLabel;

/** 全屏/正常按钮 */
@property (nonatomic, strong) UIButton *fullScreenOrNormalBtn;

@end

@implementation MTControllerView

- (instancetype)init{
    if (self = [super init]) {
        [self configContent];
    }
    return self;
}

/**
 *  配置内容视图
 **/
- (void)configContent{
    self.backgroundColor = [UIColor clearColor];
    self.viewHeight = 50.f;
    [self configTopView];
    [self configBottomView];
}

/**
 *  配置顶部视图
 **/
- (void)configTopView{
    MTWeakSelf;
    [self addSubview:self.topView];
    [self.topView addSubview:self.quitBtn];
    [self.topView addSubview:self.videoName];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(weakSelf.viewHeight);
    }];
    
    CGSize quitBtnSize = CGSizeMake(30, 30);
    [self.quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topView).offset(5);
        make.centerY.equalTo(weakSelf.topView);
        make.size.mas_equalTo(quitBtnSize);
    }];
    
    [self.videoName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.quitBtn.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.quitBtn);
    }];
}

/**
 *  配置底部视图
 **/
- (void)configBottomView{
    MTWeakSelf;

    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.playOrPauseBtn];
    [self.bottomView addSubview:self.currentTimeLabel];
    [self.bottomView addSubview:self.progressView];
#warning 缺少可以拖拽的进度条
    [self.bottomView addSubview:self.totalTimeLabel];
    [self.bottomView addSubview:self.fullScreenOrNormalBtn];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf);
        make.height.mas_equalTo(weakSelf.viewHeight);
    }];
    
    CGSize playOrPauseBtnSize = CGSizeMake(40, 40);
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bottomView).offset(5);
        make.centerY.equalTo(weakSelf.bottomView);
        make.size.mas_equalTo(playOrPauseBtnSize);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.playOrPauseBtn.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.playOrPauseBtn);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.currentTimeLabel.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.playOrPauseBtn);
        make.height.mas_equalTo(1);
        make.right.equalTo(weakSelf.totalTimeLabel.mas_left).offset(-5);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.playOrPauseBtn);
        make.right.equalTo(weakSelf.fullScreenOrNormalBtn.mas_left).offset(-5);
    }];
    
    [self.fullScreenOrNormalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.playOrPauseBtn);
        make.right.equalTo(weakSelf.bottomView.mas_right).offset(-5);
        make.size.mas_equalTo(playOrPauseBtnSize);
    }];
}

/**
 *  播放或者暂停视频
 **/
- (void)playVideoOrPause:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [[MTPlayer sharedInstance] play];
    }else{
        [[MTPlayer sharedInstance] pause];
    }
}

/**
 *  全屏或者正常显示
 **/
- (void)fullScreen:(UIButton *)btn{
    btn.selected = !btn.selected;
}

/**
 *  退出播放视频
 **/
- (void)quitVideo:(UIButton *)btn{
    
}

#pragma mark - getter
- (UIView *)topView{
    if (_topView == nil) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor orangeColor];
    }
    return _topView;
}

- (UIButton *)quitBtn{
    if (_quitBtn == nil) {
        _quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _quitBtn.backgroundColor = [UIColor clearColor];
        [_quitBtn addTarget:self action:@selector(quitVideo:) forControlEvents:UIControlEventTouchUpInside];
        _quitBtn.adjustsImageWhenHighlighted = NO;
        UIImage *quitBtnImage = [UIImage imageNamed:MTPlayerImage(@"MTPlayer_back_full")];
        [_quitBtn setImage:quitBtnImage forState:UIControlStateNormal];
    }
    return _quitBtn;
}

- (UILabel *)videoName{
    if (_videoName == nil) {
        _videoName = [UILabel new];
        _videoName.backgroundColor = [UIColor clearColor];
        _videoName.font = [UIFont systemFontOfSize:14.f];
        _videoName.textColor = [UIColor whiteColor];
    }
    return _videoName;
}

- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor orangeColor];
    }
    return _bottomView;
}

- (UIButton *)playOrPauseBtn{
    if (_playOrPauseBtn == nil) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playOrPauseBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _playOrPauseBtn.adjustsImageWhenHighlighted = NO;
        _playOrPauseBtn.backgroundColor = [UIColor clearColor];
        UIImage *playImage = [UIImage imageNamed:MTPlayerImage(@"MTPlayer_play")];
        UIImage *pauseImage = [UIImage imageNamed:MTPlayerImage(@"MTPlayer_pause")];
        [_playOrPauseBtn setImage:playImage forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:pauseImage forState:UIControlStateSelected];
        [_playOrPauseBtn addTarget:self action:@selector(playVideoOrPause:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playOrPauseBtn;
}

- (UILabel *)currentTimeLabel{
    if (_currentTimeLabel == nil) {
        _currentTimeLabel = [UILabel new];
        _currentTimeLabel.font = [UIFont systemFontOfSize:11.f];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.backgroundColor = [UIColor clearColor];
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

- (UIProgressView *)progressView{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressView.trackTintColor    = [UIColor clearColor];
    }
    return _progressView;
}

- (UILabel *)totalTimeLabel{
    if (_totalTimeLabel == nil) {
        _totalTimeLabel = [UILabel new];
        _totalTimeLabel.font = [UIFont systemFontOfSize:11.f];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.backgroundColor = [UIColor clearColor];
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenOrNormalBtn{
    if (_fullScreenOrNormalBtn == nil) {
        _fullScreenOrNormalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreenOrNormalBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullScreenOrNormalBtn.adjustsImageWhenHighlighted = NO;
        _fullScreenOrNormalBtn.backgroundColor = [UIColor clearColor];
        UIImage *fullScreenImage = [UIImage imageNamed:MTPlayerImage(@"MTPlayer_fullscreen")];
        UIImage *normalScreenImage = [UIImage imageNamed:MTPlayerImage(@"MTPlayer_back_full")];
        [_fullScreenOrNormalBtn setImage:fullScreenImage forState:UIControlStateNormal];
        [_fullScreenOrNormalBtn setImage:normalScreenImage forState:UIControlStateSelected];
        [_fullScreenOrNormalBtn addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenOrNormalBtn;
}

#pragma mark - setter

- (void)setCurrentTime:(NSInteger)currentTime{
    _currentTime = currentTime;
    NSInteger min = currentTime / 60;
    NSInteger sec = currentTime % 60;
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)min, (int)sec];
}

- (void)setTotalTime:(NSInteger)totalTime{
    _totalTime = totalTime;
    NSInteger min = totalTime / 60;
    NSInteger sec = totalTime % 60;
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)min, (int)sec];
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self.progressView setProgress:progress animated:NO];
}

@end
