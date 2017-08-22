//
//  MTControllerView.h
//  Test
//
//  Created by MenThu on 2017/8/15.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTControllerView : UIView

/**
 *  当前播放时间(单位秒)
 **/
@property (nonatomic, assign) NSInteger currentTime;

/**
 *  总播放时间(单位秒)
 **/
@property (nonatomic, assign) NSInteger totalTime;

/**
 *  播放进度
 **/
@property (nonatomic, assign) CGFloat playValue;

/**
 *  缓冲进度
 **/
@property (nonatomic, assign) CGFloat progress;

@end
