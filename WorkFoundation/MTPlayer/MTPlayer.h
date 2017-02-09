//
//  MTPlayer.h
//  MTVideoPlayer
//
//  Created by MenThu on 2016/12/27.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTPlayer : UIView

/**
    初始化
 **/
- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSString *)url;

/**
    开始播放
 **/
- (void)startPlay;

/**
    暂停
 **/
- (void)pause;

/**
    屏幕旋转的block
    orientaionType 
        0   -   正常
        1   -   全屏
 **/
@property (nonatomic, copy) void (^orientaionBlock) (NSInteger orientaionType);

@end
