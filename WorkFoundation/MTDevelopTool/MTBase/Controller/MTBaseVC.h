//
//  MTBaseVC.h
//  rrmjMT
//
//  Created by MenThu on 2016/12/9.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTBaseVC : UIViewController

/**
    子类内容视图
 **/
@property (nonatomic, weak) UIView *contentView;

/**
    左右UIBarButtonItem距离屏幕的距离的偏移量[0,0]
 **/
@property (nonatomic, strong) NSArray <NSNumber *> *item2ScreenSpace;

/**
    子类自定navigationItem的入口，最后调用[super configNavigationItem]调整左右的间距
 **/
- (void)configNavigationItem;

/**
    子类控制器的入口函数[父类调用]
 **/
- (void)configView;

/**
    子类的请求工作[父类调用]
 **/
- (void)startHttpRequest;

/**
    请求结束[子类调用]
 **/
- (void)endHttpRequest;

@end
