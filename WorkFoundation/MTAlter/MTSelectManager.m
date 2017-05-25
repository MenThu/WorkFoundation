//
//  MTSelectManager.m
//  artapp
//
//  Created by MenThu on 17/5/24.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "MTSelectManager.h"

@interface MTSelectManager ()


@end

@implementation MTSelectManager

+ (void)showWith:(MTAlterInfo *)alertInfo{
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:alertInfo.mtTitle message:alertInfo.mtMessage preferredStyle:alertInfo.style];
    for (MTAction *mtAction in alertInfo.actionArray) {
        UIAlertAction *alterAction = [UIAlertAction actionWithTitle:mtAction.mtActionTitle style:mtAction.style handler:^(UIAlertAction * _Nonnull action) {
            if (mtAction.tapAction) {
                mtAction.tapAction();
            }
        }];
        [alterController addAction:alterAction];
    }
    
    UIViewController *currenController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [currenController presentViewController:alterController animated:YES completion:nil];
    
//    UINavigationController *navi = (UINavigationController *)[(UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController selectedViewController];
//    [navi.topViewController presentViewController:mtAlter animated:YES completion:nil];
}

@end
