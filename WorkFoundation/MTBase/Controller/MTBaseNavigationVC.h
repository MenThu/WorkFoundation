//
//  MTBaseNavigationVC.h
//  rrmjMT
//
//  Created by MenThu on 2016/12/9.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTBaseNavigationVC : UINavigationController

@property (nonatomic, strong) UIImageView *navibarImage;

- (void)setBarAlpha;
- (void)setBarNormal;

@end
