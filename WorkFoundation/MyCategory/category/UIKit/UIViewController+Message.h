//
//  UIViewController+Hint.h
//  BM4Group
//
//  Created by 陈宇 on 16/2/1.
//  Copyright © 2016年 陈宇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HintType) {
    HintTypeSuccessful,
    HintTypeFailure,
};

@interface UIViewController (Message)

/**
 *  显示HintTypeSuccessful且offset为0的message
 *
 *  @param message 显示的文字
 */
- (void)showMessage:(NSString *)message;

/**
 *  根据HintType显示Message，默认offset为0
 *
 *  @param message 显示的文字
 *  @param type    显示的消息类型
 */
- (void)showMessage:(NSString *)message type:(HintType)type;

/**
 *  显示HintTypeSuccessful的Message
 *
 *  @param message 显示的文字
 *  @param offset  偏移量
 */
- (void)showMessage:(NSString *)message offset:(CGFloat)offset;

/**
 *  显示消息
 *
 *  @param message 显示的文字
 *  @param type    显示的消息类型
 *  @param offset  偏移量
 */
- (void)showMessage:(NSString *)message type:(HintType)type offset:(CGFloat)offset;

@end
