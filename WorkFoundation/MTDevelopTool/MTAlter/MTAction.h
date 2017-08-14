//
//  MTAction.h
//  artapp
//
//  Created by MenThu on 17/5/24.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MTAction : NSObject

/**
 *  Action的姓名
 **/
@property (nonatomic, copy) NSString *mtActionTitle;

/**
 *  action的风格
 **/
@property (nonatomic, assign) UIAlertActionStyle style;

/**
 *  点击的操作
 **/
@property (nonatomic, copy) void (^tapAction) (void);

@end
