//
//  MTLivePlayer.h
//  LiveDepProject
//
//  Created by MenThu on 2017/2/10.
//  Copyright © 2017年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTLivePlayer : NSObject

/**
    更改大小，拖拽，自定义内容的容器
    在调用完initWithView:liveUrlStr:之后使用
 **/
@property (nonatomic, strong) UIView *contentView;

/**
 *   @params controllerView 控制器的视图
 *   @params liveUrlString  拉流的url
 *   @params imageUrlStr    预加载图片
 **/
- (instancetype)initWithView:(UIView *)controllerView liveUrlStr:(NSString *)liveUrlString placeHoldImage:(NSString *)imageUrlStr toolBlcok:(void (^) (UIView *contentView))customViewBlock;

/**
    开始播放[或回复播放]
 **/
- (void)startPlay;

/**
 *  暂停/回复播放
 *  @params isResume yes 回复 no 暂停
 **/
- (void)resumeOrPause:(BOOL)isResume;

/**
    停止播放
 **/
- (void)stopPlay;

@end
