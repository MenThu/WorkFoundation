//
//  UIViewController+BM.h
//  BM4Group
//
//  Created by Chrain on 15/6/5.
//  Copyright (c) 2015年 蓝色互动武汉项目4部. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Hint)

#if __has_include(<MBProgressHUD/MBProgressHUD.h>)
/**
 *  显示一个类似于android的Toast的提示消息。
 *
 *  @param hint message
 */
- (void)showHint:(NSString *)hint;

/// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

#endif

/**
 *  快快速弹出一个显示alert的消息，只有一个确定按钮，不做任何操作。
 *
 *  @param message message
 */
- (void)alertWith:(NSString *)message;

/**
 *  快快速弹出一个显示alert的消息，确定按钮可以传入对应操作。
 *
 *  @param message mesage
 *  @param ok      确定按钮对应的操作
 */
- (void)alertWith:(NSString *)message okHandler:(dispatch_block_t)okHandler;

@end
