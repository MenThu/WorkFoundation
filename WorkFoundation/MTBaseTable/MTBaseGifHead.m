//
//  MTBaseGifHead.m
//  TestStoryboard
//
//  Created by MenThu on 2016/11/23.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseGifHead.h"

@interface MTBaseGifHead ()

{
    //图片宽高比例
    CGFloat _imageScale;
    CGFloat _normalImageWidth;
    CGFloat _normalImageHeight;
    CGFloat _space;
    CGFloat _lablHeight;
    CGPoint _gifViewCenter;
    CGFloat _totalHeightScale;
}

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *hintLabel;
@property (nonatomic, strong) UIImageView *gifView;
@property (nonatomic, assign) BOOL isHaveTitle;
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

@end

@implementation MTBaseGifHead

+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    MTBaseGifHead *mj_head = [super headerWithRefreshingBlock:refreshingBlock];
    mj_head.stateLabel.hidden = YES;
    mj_head.lastUpdatedTimeLabel.hidden = YES;
    
    [mj_head addSubview:mj_head.titleLabel];
    [mj_head addSubview:mj_head.hintLabel];
    mj_head.isHaveTitle = NO;
    return mj_head;
}

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.titleLabel.text = titleString;
    self.hintLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.hidden = NO;
    _isHaveTitle = YES;
}

- (void)setIamgesArray:(NSArray<UIImage *> *)iamgesArray{
    _iamgesArray = iamgesArray;
}

- (void)setGifTime:(CGFloat)gifTime{
    _gifTime = gifTime;
}

//最后做的初始化
- (void)prepareMTGifHead{
    self.backgroundColor = [UIColor orangeColor];
    
    
    [self setImages:_iamgesArray duration:self.gifTime forState:MJRefreshStateIdle];
    [self setImages:_iamgesArray duration:self.gifTime forState:MJRefreshStatePulling];
    [self setImages:_iamgesArray duration:self.gifTime forState:MJRefreshStateRefreshing];
    
    _lablHeight = 30.f;
    _space = 10.f;
    if (_isHaveTitle) {
        //调整图片和Label的frame，使其整体居中
        CGFloat labelWidth = [self.titleString widthForFont:self.titleLabel.font];
        self.titleLabel.frame = CGRectMake((YYScreenSize().width-(_space+_normalImageWidth+labelWidth))/2+_normalImageWidth+_space, (self.mj_h-(2*_lablHeight+_space))/2, labelWidth, _lablHeight);
        self.hintLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame)+ 20 , CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame));
        _gifViewCenter = CGPointMake(CGRectGetMinX(self.titleLabel.frame)-_space-_normalImageWidth/2, CGRectGetHeight(self.frame)/2);
    }else{
        self.mj_h = _space*3 + _lablHeight + _normalImageHeight;
        //上下居中
        self.hintLabel.frame = CGRectMake(_space, CGRectGetHeight(self.frame)-_lablHeight-_space, YYScreenSize().width-2*_space, _lablHeight);
    }
    self.gifView.frame = CGRectZero;
}

#pragma mark - 内部方法
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state
{
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    CGFloat imageHeight = 0.f;
    if (image.size.height > imageHeight) {
        imageHeight = image.size.height;
        imageHeight = MIN(90.f, imageHeight);
    }
    
    _imageScale = image.size.width / image.size.height;
    _totalHeightScale = 0.7;
    _normalImageHeight = imageHeight;
    self.mj_h = imageHeight / _totalHeightScale;
    _normalImageWidth = _imageScale * _normalImageHeight;
}

#pragma mark - 实现父类的方法
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) return;
    // 停止动画
    [self.gifView stopAnimating];
    // 设置当前需要显示的图片
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
    
    
    CGFloat scale = MIN(1, pullingPercent);
    if (_isHaveTitle && scale > 0) {
        self.gifView.frame = CGRectMake(_gifViewCenter.x-_normalImageWidth*scale/2, self.mj_h*(1-scale/2)-_normalImageHeight*scale/2, _normalImageWidth*scale, _normalImageHeight*scale);
    }else{
        CGFloat imageTotalSpace = CGRectGetHeight(self.frame)*scale - _lablHeight - 3*_space;
        if (imageTotalSpace <= 0) {
            return;
        }
        CGFloat imageHeight = imageTotalSpace *scale;
        CGFloat imageWidth = imageHeight * _imageScale;
        self.gifView.frame = CGRectMake((self.mj_w-imageWidth)/2, CGRectGetHeight(self.frame) - _space*2 - _lablHeight - imageHeight, imageWidth, imageHeight);
    }
    if (scale>0) {
        self.gifView.layer.cornerRadius = self.gifView.width/2;
    }
}

- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState
    // 根据状态做事情
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
        [self.gifView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        } else { // 多张图片
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    } else if (state == MJRefreshStateIdle) {
        [self.gifView stopAnimating];
    }
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            self.hintLabel.text = @"下拉更新";
        }
            break;
        case MJRefreshStatePulling:
        {
            self.hintLabel.text = @"松手更新";
        }
            break;
        case MJRefreshStateRefreshing:
        {
            self.hintLabel.text = @"正在更新中...";
        }
            break;
        default:
            break;
    }
}


//懒加载
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.text = @"MTBaseGifLabel";
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.hidden = YES;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        gifView.contentMode = UIViewContentModeScaleAspectFill;
        gifView.clipsToBounds = YES;
        gifView.layer.masksToBounds = YES;
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        UILabel *hintLabel = [[UILabel alloc] init];
        hintLabel.font = [UIFont systemFontOfSize:13];
        hintLabel.textAlignment = NSTextAlignmentCenter;
        hintLabel.textColor = [UIColor blackColor];
        _hintLabel = hintLabel;
        
    }
    return _hintLabel;
}

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

@end
