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

@property (nonatomic, strong) NSArray <MTPhotoPreviewModel *> *photoArray;
- (void)showFromViewController:(UIViewController *)viewController;
- (void)dismiss;
- (void)hiddenNavibar;

@end
