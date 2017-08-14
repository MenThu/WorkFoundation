//
//  MTPlayerVC.m
//  artapp
//
//  Created by MenThu on 2017/3/9.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "MTPlayerVC.h"
#import "MTToolPlayer.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MTPlayerVC ()

@property (nonatomic, strong) MTToolPlayer *mtPlayer;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, assign) BOOL statusBarHidden;

@end

@implementation MTPlayerVC

- (void)configView{
    [super configView];
    MTWeakSelf;
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mtPlayer];
    self.mtPlayer.quitPlayer = ^(){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.mtPlayer startPlay];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)dealloc{
    MyLog(@"playVC die");
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    MyLog(@"MTPlayerVC layoutSubviews");
}

- (MTToolPlayer *)mtPlayer{
    if (!_mtPlayer) {
        _mtPlayer = [[MTToolPlayer alloc] initWithFrame:CGRectMake(0, 0, MTScreenSize().width, MTScreenSize().height)];
    }
    return _mtPlayer;
}

#pragma mark - getter, setter
- (void)setVideoUrlStr:(NSString *)videoUrlStr{
    _videoUrlStr = videoUrlStr;
    self.mtPlayer.videoUrl = videoUrlStr;
}

- (void)setShareInfo:(NSDictionary *)shareInfo{
    _shareInfo = shareInfo;
    self.mtPlayer.shareInfo = shareInfo;
}

@end
