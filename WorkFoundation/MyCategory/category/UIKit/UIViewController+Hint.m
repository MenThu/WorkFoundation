//
//  UIViewController+BM.m
//  BM4Group
//
//  Created by Chrain on 15/6/5.
//  Copyright (c) 2015年 蓝色互动武汉项目4部. All rights reserved.
//

#import "UIViewController+Hint.h"
#import <objc/runtime.h>

#if __has_include(<MBProgressHUD/MBProgressHUD.h>)
#import "MBProgressHUD.h"
#endif

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (Hint)

#if __has_include(<MBProgressHUD/MBProgressHUD.h>)
- (void)showHint:(NSString *)hint
{
    [self showHint:hint yOffset:0.f];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    if ([self isViewLoaded] && self.view.window) {
        //显示提示信息
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        UIView *view = [[UIApplication sharedApplication].delegate window];
        NSArray * huds = [MBProgressHUD allHUDsForView:view];
        [huds makeObjectsPerformSelector:@selector(removeFromSuperview)];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.animationType = MBProgressHUDAnimationZoom;
        hud.opacity = 0.5;
        hud.detailsLabelText = hint;
        hud.margin = 10.f;
        hud.yOffset = 200.f;
        hud.yOffset += yOffset;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5f];
#pragma clang diagnostic pop
    }
}
#endif

- (void)alertWith:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", @"确定") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)alertWith:(NSString *)message okHandler:(dispatch_block_t)okHandler
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"str_calcle", @"取消") style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"str_ok", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        okHandler();
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
