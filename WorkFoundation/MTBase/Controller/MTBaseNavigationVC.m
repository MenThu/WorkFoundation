//
//  MTBaseNavigationVC.m
//  rrmjMT
//
//  Created by MenThu on 2016/12/9.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseNavigationVC.h"

@interface MTBaseNavigationVC ()

@end

@implementation MTBaseNavigationVC

+ (void)initialize{
    [self setNavigationBarTheme];
    [self setNavigationBarButtonItemTheme];
}

+(void)setNavigationBarTheme
{
    UINavigationBar *naviBar = [UINavigationBar appearance];
//    naviBar.translucent = YES;
    //导航栏背景色 去掉铺盖在UINavigationBar上面杂七杂八的view
    [naviBar setBackgroundImage:[UIImage imageWithColor:LineColor] forBarMetrics:UIBarMetricsDefault];
    //设置导航字体主题
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [naviBar setTitleTextAttributes:dict];
    [naviBar setShadowImage:[[UIImage alloc] init]];
    naviBar.tintColor = [UIColor whiteColor];
}

- (UIImageView *)navibarImage{
    if (!_navibarImage) {
        for (UIView *barBackground in self.navigationBar.subviews) {
            if ([barBackground isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                _navibarImage = (UIImageView *)barBackground.subviews[0];
                break;
            }
        }
    }
    return _navibarImage;
}

- (void)setBarAlpha{
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
}

- (void)setBarNormal{
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:LineColor] forBarMetrics:UIBarMetricsDefault];
}

+(void)setNavigationBarButtonItemTheme
{
    UIBarButtonItem*item = [UIBarButtonItem appearance];
    
    //设置普通状态下文字属性
    NSMutableDictionary*dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    //设置高亮状态下文字属性
    NSMutableDictionary*dict1 = [NSMutableDictionary dictionary];
    dict1[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    dict1[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:dict1 forState:UIControlStateHighlighted];
    
    //设置不可用的状态下文字属性
    NSMutableDictionary*dict2 = [NSMutableDictionary dictionary];
    dict2[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    dict2[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:dict2 forState:UIControlStateDisabled];
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
