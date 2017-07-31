//
//  MTPhotoPreviewControler.h
//  artapp
//
//  Created by MenThu on 17/7/11.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "MTBaseCollectionVC.h"
#import "MTPhotoPreviewModel.h"

@interface MTPhotoPreviewControler : MTBaseCollectionVC

/**
 *  数据源
 **/
@property (nonatomic, strong) NSArray <MTPhotoPreviewModel *> *photoArray;

/**
 *  滚动方向，YES为水平方向
 *  NO为竖直方向
 **/
@property (nonatomic, assign) BOOL scrollDirection;

/**
 *  显示方法
 **/
- (void)showFromViewController:(UIViewController *)viewController;

/**
 *  显示方法
 **/
- (void)dismiss;

/**
 *  隐藏导航栏
 **/
- (void)hiddenNavibar;

@end
