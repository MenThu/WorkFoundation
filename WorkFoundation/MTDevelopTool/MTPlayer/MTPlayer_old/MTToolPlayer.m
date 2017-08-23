//
//  MTToolPlayer.m
//  MTTest
//
//  Created by MenThu on 2017/3/31.
//  Copyright © 2017年 官辉. All rights reserved.
//

#import "MTToolPlayer.h"
#import "MTSlider.h"
@interface MTToolPlayer ()
{
    CGFloat _btnWidth;
}

//顶部菜单栏
@property (nonatomic, strong) UIView *topMenuView;
//退出
@property (nonatomic, strong) UIButton *quitBtn;
//分享
@property (nonatomic, strong) UIButton *shareBtn;

//底部工具栏
@property (nonatomic, strong, readwrite) UIView *toolView;
//播放暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
//缓冲视图
@property (nonatomic, strong) UIProgressView *loadingProgressView;
//播放进度条
@property (nonatomic, strong) MTSlider *progressSlider;
//左侧时间
@property (nonatomic, strong) UILabel *leftCurrentLabel;
//右侧时间
@property (nonatomic, strong) UILabel *rightTotalLabel;
//全屏按钮
@property (nonatomic, strong) UIButton *fullOrSmallScreenBtn;
//工具栏高度
@property (nonatomic, assign) CGFloat toolHeight;
//视频总时长
@property (nonatomic, assign) CGFloat totalTime;

@property (nonatomic, assign) CGRect normalFrame;

@end

@implementation MTToolPlayer

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.normalFrame = frame;
    }
    return self;
}

- (void)configContentView{
    [super configContentView];
    [self configToolPlayerView];
    UITapGestureRecognizer *hideToolView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenuAndToolBar)];
    [self addGestureRecognizer:hideToolView];
}

- (void)setShareInfo:(NSDictionary *)shareInfo{
    _shareInfo = shareInfo;
    self.shareBtn.hidden = NO;
}

- (void)hideMenuAndToolBar{
    self.toolView.hidden = !self.toolView.hidden;
    self.topMenuView.hidden = !self.topMenuView.hidden;
    if (self.tapGesture) {
        self.tapGesture(self.toolView.hidden);
    }
}

- (void)initVaribles{
    [super initVaribles];
    self.totalTime = 1.f;
    self.timeInterval = 1;
    self.toolHeight = 50.f;
    self->_btnWidth = 60.f;
    
    MTWeakSelf;
    /**
     当前播放时间的进度，可以为nil
     **/
    self.intervalBlock = ^(CGFloat currentTime){
        MyLog(@"%s %.f", __func__, currentTime);
        //更改左侧Label显示
        weakSelf.leftCurrentLabel.text = [NSString convertTime:currentTime];
        //更改底部进度条显示
        CGFloat value = currentTime;
        [weakSelf.progressSlider setValue:value];
    };
    
    //获取视频总时长，可以为nil
    self.totalTimeBlock = ^(CGFloat totalTime){
        weakSelf.totalTime = totalTime;
        weakSelf.progressSlider.maximumValue = totalTime;
        weakSelf.rightTotalLabel.text = [NSString convertTime:totalTime];
    };
    
    //视频缓冲进度回调
    self.bufferBlock = ^(CGFloat bufferSchedule){
        [weakSelf.loadingProgressView setProgress:bufferSchedule animated:NO];
    };
    
    //配置播放完成的block
    self.playerFinsh = ^(){
        weakSelf.progressSlider.value = weakSelf.totalTime;
        weakSelf.playOrPauseBtn.selected = NO;
        weakSelf.leftCurrentLabel.text = [NSString convertTime:weakSelf.totalTime];
    };
}

- (void)quitVideoPlayer{
    if (self.superview && [self.superview isKindOfClass:[UIWindow class]]) {
        [self removeFromSuperview];
    }
    if (self.quitPlayer) {
        self.quitPlayer();
    }
}

- (void)share{
    
}

- (void)configToolPlayerView{
    //顶部菜单栏
    UIView *topMenuView = [[UIView alloc] init];
    topMenuView.backgroundColor = MTColor(0, 0, 0, 0.7);
    [self addSubview:(_topMenuView = topMenuView)];
    
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [quitBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quitBtn addTarget:self action:@selector(quitVideoPlayer) forControlEvents:UIControlEventTouchUpInside];
    [topMenuView addSubview:(_quitBtn = quitBtn)];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"MusicSqaure_whiteshare"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    //有分享信息时才显示
    shareBtn.hidden = YES;
    [topMenuView addSubview:(_shareBtn = shareBtn)];
    
    //底部工具栏
    UIView *toolView = [[UIView alloc] init];
    toolView.backgroundColor = MTColor(0, 0, 0, 0.7);
    [self addSubview:(_toolView = toolView)];
    
    //左侧播放暂停按钮
    UIButton *playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playOrPauseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [playOrPauseBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playOrPauseBtn setTitle:@"暂停" forState:UIControlStateSelected];
    [playOrPauseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playOrPauseBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:(_playOrPauseBtn = playOrPauseBtn)];
    
    //进度条
    UIProgressView *loadingProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    loadingProgressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    loadingProgressView.trackTintColor    = [UIColor blackColor];
    [loadingProgressView setProgress:0.0 animated:NO];
    [toolView addSubview:(_loadingProgressView = loadingProgressView)];
    
    //中间进度条
    MTSlider *progressSlider = [[MTSlider alloc] init];
    progressSlider.backgroundColor = [UIColor clearColor];
    progressSlider.minimumValue = 0.0;
    progressSlider.maximumValue = 1.0;
    [progressSlider setThumbImage:[UIImage imageNamed:@"sliderDot"]  forState:UIControlStateNormal];
    progressSlider.minimumTrackTintColor = [UIColor greenColor];
    progressSlider.maximumTrackTintColor = [UIColor whiteColor];
    progressSlider.value = 0.0;//指定初始值
    [progressSlider addTarget:self action:@selector(stratDragSlide:)  forControlEvents:UIControlEventValueChanged];//进度条的拖拽事件
    [progressSlider addTarget:self action:@selector(updateProgressInside:) forControlEvents:UIControlEventTouchUpInside];//进度条的点击事件
    [progressSlider addTarget:self action:@selector(updateProgressInside:) forControlEvents:UIControlEventTouchUpOutside];
    [toolView addSubview:(_progressSlider = progressSlider)];
    
    //左侧时间按钮
    UILabel *leftCurrentLabel = [[UILabel alloc] init];
    leftCurrentLabel = [[UILabel alloc]init];
    leftCurrentLabel.textAlignment = NSTextAlignmentLeft;
    leftCurrentLabel.textColor = [UIColor whiteColor];
    leftCurrentLabel.backgroundColor = [UIColor clearColor];
    leftCurrentLabel.font = [UIFont systemFontOfSize:11];
    leftCurrentLabel.text = [NSString convertTime:0.0];//设置默认值
    [toolView addSubview:(_leftCurrentLabel = leftCurrentLabel)];
    
    //右侧总体时间按钮
    UILabel *rightTotalLabel = [[UILabel alloc] init];
    rightTotalLabel = [[UILabel alloc] init];
    rightTotalLabel.textAlignment = NSTextAlignmentRight;
    rightTotalLabel.textColor = [UIColor whiteColor];
    rightTotalLabel.backgroundColor = [UIColor clearColor];
    rightTotalLabel.font = [UIFont systemFontOfSize:11];
    rightTotalLabel.text = [NSString convertTime:0.0];//设置默认值
    [toolView addSubview:(_rightTotalLabel = rightTotalLabel)];
    
    //右侧全屏按钮
    UIButton *fullOrSmallScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fullOrSmallScreenBtn addTarget:self action:@selector(fullOrSmall:) forControlEvents:UIControlEventTouchUpInside];
    fullOrSmallScreenBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fullOrSmallScreenBtn setTitle:@"全屏" forState:UIControlStateNormal];
    [fullOrSmallScreenBtn setTitle:@"正常" forState:UIControlStateSelected];
    [fullOrSmallScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [toolView addSubview:(_fullOrSmallScreenBtn = fullOrSmallScreenBtn)];
}

- (void)setVideoUrl:(NSString *)videoUrl{
    [super setVideoUrl:videoUrl];
    [self normalLayout];
}

#pragma mark - 底部工具条操作
//播放
- (void)playBtnClick:(UIButton *)playBtn{
    if (playBtn.selected == YES) {
        //暂停
        [self pause];
    }else{
        [self startPlay];
    }
}

- (void)stratDragSlide:(UISlider *)slider{
    self.leftCurrentLabel.text = [NSString convertTime:slider.value];
    [self pause];
    MTWeakSelf;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf.avPlayer seekToTime:CMTimeMakeWithSeconds(slider.value, weakSelf.avPlayerItem.currentTime.timescale)];
    });
}

- (void)updateProgressInside:(UISlider *)slider{
    self.leftCurrentLabel.text = [NSString convertTime:slider.value];
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(slider.value, self.avPlayerItem.currentTime.timescale)];
    [self startPlay];
}

- (void)startPlay{
    [super startPlay];
    self.playOrPauseBtn.selected = YES;
}

- (void)pause{
    [super pause];
    self.playOrPauseBtn.selected = NO;
}

//全屏操作
- (void)fullOrSmall:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        //全屏
        [self fullScreen];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }else{
        [self halfScreen];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    if (self.isPlayerFullScreen) {
        self.isPlayerFullScreen(button.selected);
    }
}

- (void)fullScreen
{
    MTWeakSelf;
    if (self.normalSuperView == nil) {
        //外部未设置superView，采用self.superView
        self.normalSuperView = self.superview;
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = CGRectMake(0, 0, MTScreenSize().width, MTScreenSize().height);
    //AVPlayerLayer
    self.avPlayerLayer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
    self.avPlayerLayer.frame = CGRectMake(0, 0, MTScreenSize().width, MTScreenSize().height);
    //处理顶部信息栏顶部的布局
    //处理底部工具条的布局
    [UIView animateWithDuration:0.3 animations:^{
        //菜单栏
        weakSelf.topMenuView.transform = CGAffineTransformMakeRotation(M_PI_2);
        CGFloat topMenuWidth = weakSelf.toolHeight;
        CGFloat topMenuHeight = MTScreenSize().height;
        CGFloat topMenuOriginx = MTScreenSize().width-topMenuWidth;
        CGFloat topMenuOriginy = 0;
        self.topMenuView.frame = CGRectMake(topMenuOriginx, topMenuOriginy, topMenuWidth, topMenuHeight);
        
        //退出
        CGFloat quitBtnOriginx = 0;
        CGFloat quitBtnOriginy = 0;
        CGFloat quitBtnWidth = self->_btnWidth;
        CGFloat quitBtnHeight = CGRectGetWidth(weakSelf.topMenuView.frame);
        self.quitBtn.frame = CGRectMake(quitBtnOriginx, quitBtnOriginy, quitBtnWidth, quitBtnHeight);
        
        //分享
        CGFloat shareBtnWidth = self->_btnWidth;
        CGFloat shareBtnHeight = CGRectGetWidth(weakSelf.topMenuView.frame);
        CGFloat shareBtnOriginx = CGRectGetHeight(weakSelf.topMenuView.frame)-shareBtnWidth;
        CGFloat shareBtnOriginy = CGRectGetMinY(weakSelf.quitBtn.frame);
        self.shareBtn.frame = CGRectMake(shareBtnOriginx, shareBtnOriginy, shareBtnWidth, shareBtnHeight);

        //工具条
        weakSelf.toolView.transform = CGAffineTransformMakeRotation(M_PI_2);
        weakSelf.toolView.frame = CGRectMake(0, 0, weakSelf.toolHeight, MTScreenSize().height);
        weakSelf.playOrPauseBtn.frame = CGRectMake(100, 20, 100, 30);
        
        //播放暂停按钮
        CGFloat playOrPauseBtnOringinx = 0;
        CGFloat playOrPauseBtnOringiny = 0;
        CGFloat playOrPauseBtnWidth = self->_btnWidth;
        CGFloat playOrPauseBtnHeight = weakSelf.toolHeight;
        self.playOrPauseBtn.frame = CGRectMake(playOrPauseBtnOringinx, playOrPauseBtnOringiny, playOrPauseBtnWidth, playOrPauseBtnHeight);
        
        //进度条
        CGFloat sliderOriginx = CGRectGetMaxX(weakSelf.playOrPauseBtn.frame);
        CGFloat sliderOriginy = CGRectGetMinY(weakSelf.playOrPauseBtn.frame);
        CGFloat sliderWidth = CGRectGetHeight(weakSelf.toolView.frame) - 2*self->_btnWidth;
        CGFloat sliderHeight = CGRectGetWidth(weakSelf.toolView.frame);
        self.progressSlider.frame = CGRectMake(sliderOriginx, sliderOriginy, sliderWidth, sliderHeight);
        
        //加载进度条
        CGFloat loadingProgressWidth = sliderWidth;
        CGFloat loadingProgressHeight = 2;
        CGFloat loadingProgressOriginx = sliderOriginx;
        CGFloat loadingProgressOriginy = (sliderOriginy + sliderHeight)/2-loadingProgressHeight/2;
        self.loadingProgressView.frame = CGRectMake(loadingProgressOriginx, loadingProgressOriginy, loadingProgressWidth, loadingProgressHeight);
        
        //左侧时间Label
        CGFloat leftLabelWidth = sliderWidth/2;
        CGFloat leftLabelHeight = sliderHeight*0.4;
        CGFloat leftLabelOriginx = sliderOriginx;
        CGFloat leftLabelOriginy = sliderHeight-leftLabelHeight;
        self.leftCurrentLabel.frame = CGRectMake(leftLabelOriginx, leftLabelOriginy, leftLabelWidth, leftLabelHeight);
        
        //右侧时间Label
        CGFloat rightLabelWidth = leftLabelWidth;
        CGFloat rightLabelHeight = leftLabelHeight;
        CGFloat rightLabelOriginx = CGRectGetMaxX(weakSelf.leftCurrentLabel.frame);
        CGFloat rightLabelOriginy = CGRectGetMinY(weakSelf.leftCurrentLabel.frame);
        self.rightTotalLabel.frame = CGRectMake(rightLabelOriginx, rightLabelOriginy, rightLabelWidth, rightLabelHeight);
        
        //全屏按钮
        CGFloat fullOrSmallScreenBtnOriginx = CGRectGetMaxX(weakSelf.progressSlider.frame);
        CGFloat fullOrSmallScreenBtnOriginy = CGRectGetMinY(weakSelf.playOrPauseBtn.frame);
        CGFloat fullOrSmallScreenBtnWidth = self->_btnWidth;
        CGFloat fullOrSmallScreenBtnHeight = playOrPauseBtnHeight;
        self.fullOrSmallScreenBtn.frame = CGRectMake(fullOrSmallScreenBtnOriginx, fullOrSmallScreenBtnOriginy, fullOrSmallScreenBtnWidth, fullOrSmallScreenBtnHeight);
    }];
}

- (void)halfScreen
{
    if (self.superview) {
        [self removeFromSuperview];
    }
    [self.normalSuperView addSubview:self];
    self.frame = self.normalFrame;
    self.avPlayerLayer.transform = CATransform3DIdentity;
    self.avPlayerLayer.frame = self.bounds;
    [self normalLayout];
}

- (void)normalLayout{
    
    CGFloat selfWidth = CGRectGetWidth(self.frame);
    CGFloat selfHeight = CGRectGetHeight(self.frame);
    
    self.avPlayerLayer.frame = CGRectMake(0, 0, selfWidth, selfHeight);
    
    //菜单栏
    self.topMenuView.transform = CGAffineTransformIdentity;
    CGFloat topMenuOriginx = 0;
    CGFloat topMenuOriginy = 0;
    CGFloat topMenuWidth = selfWidth;
    CGFloat topMenuHeight = self.toolHeight;
    self.topMenuView.frame = CGRectMake(topMenuOriginx, topMenuOriginy, topMenuWidth, topMenuHeight);
    
    CGFloat quitBtnOriginx = 0;
    CGFloat quitBtnOriginy = 0;
    CGFloat quitBtnWidth = self->_btnWidth;
    CGFloat quitBtnHeight = CGRectGetHeight(self.topMenuView.frame);
    self.quitBtn.frame = CGRectMake(quitBtnOriginx, quitBtnOriginy, quitBtnWidth, quitBtnHeight);
    
    CGFloat shareBtnWidth = self->_btnWidth;
    CGFloat shareBtnHeight = CGRectGetHeight(self.topMenuView.frame);
    CGFloat shareBtnOriginx = CGRectGetWidth(self.topMenuView.frame)-shareBtnWidth;
    CGFloat shareBtnOriginy = CGRectGetMinY(self.quitBtn.frame);
    self.shareBtn.frame = CGRectMake(shareBtnOriginx, shareBtnOriginy, shareBtnWidth, shareBtnHeight);
    
    //工具条
    self.toolView.transform = CGAffineTransformIdentity;
    self.toolView.frame = CGRectMake(0, selfHeight-self.toolHeight, topMenuWidth, self.toolHeight);
    
    //播放暂停按钮
    CGFloat playOrPauseBtnOringinx = 0;
    CGFloat playOrPauseBtnOringiny = 0;
    CGFloat playOrPauseBtnWidth = _btnWidth;
    CGFloat playOrPauseBtnHeight = CGRectGetHeight(self.toolView.frame);
    self.playOrPauseBtn.frame = CGRectMake(playOrPauseBtnOringinx, playOrPauseBtnOringiny, playOrPauseBtnWidth, playOrPauseBtnHeight);
    
    //进度条
    CGFloat sliderOriginx = CGRectGetMaxX(self.playOrPauseBtn.frame);
    CGFloat sliderOriginy = CGRectGetMinY(self.playOrPauseBtn.frame);
    CGFloat sliderWidth = CGRectGetWidth(self.toolView.frame) - 2*self->_btnWidth;
    CGFloat sliderHeight = CGRectGetHeight(self.toolView.frame);
    self.progressSlider.frame = CGRectMake(sliderOriginx, sliderOriginy, sliderWidth, sliderHeight);
    
    //加载进度条
    CGFloat loadingProgressWidth = sliderWidth;
    CGFloat loadingProgressHeight = 2;
    CGFloat loadingProgressOriginx = sliderOriginx;
    CGFloat loadingProgressOriginy = (sliderOriginy + sliderHeight)/2-loadingProgressHeight/2;
    self.loadingProgressView.frame = CGRectMake(loadingProgressOriginx, loadingProgressOriginy, loadingProgressWidth, loadingProgressHeight);
    
    //左侧时间Label
    CGFloat leftLabelWidth = sliderWidth/2;
    CGFloat leftLabelHeight = sliderHeight*0.4;
    CGFloat leftLabelOriginx = sliderOriginx;
    CGFloat leftLabelOriginy = sliderHeight-leftLabelHeight;
    self.leftCurrentLabel.frame = CGRectMake(leftLabelOriginx, leftLabelOriginy, leftLabelWidth, leftLabelHeight);
    
    //右侧时间Label
    CGFloat rightLabelWidth = leftLabelWidth;
    CGFloat rightLabelHeight = leftLabelHeight;
    CGFloat rightLabelOriginx = CGRectGetMaxX(self.leftCurrentLabel.frame);
    CGFloat rightLabelOriginy = CGRectGetMinY(self.leftCurrentLabel.frame);
    self.rightTotalLabel.frame = CGRectMake(rightLabelOriginx, rightLabelOriginy, rightLabelWidth, rightLabelHeight);
    
    //全屏按钮
    CGFloat fullOrSmallScreenBtnOriginx = CGRectGetMaxX(self.progressSlider.frame);
    CGFloat fullOrSmallScreenBtnOriginy = CGRectGetMinY(self.progressSlider.frame);
    CGFloat fullOrSmallScreenBtnWidth = _btnWidth;
    CGFloat fullOrSmallScreenBtnHeight = playOrPauseBtnHeight;
    self.fullOrSmallScreenBtn.frame = CGRectMake(fullOrSmallScreenBtnOriginx, fullOrSmallScreenBtnOriginy, fullOrSmallScreenBtnWidth, fullOrSmallScreenBtnHeight);
}

- (void)dealloc{
    MyLog(@"self [%@]", NSStringFromClass([self class]));
}

@end
