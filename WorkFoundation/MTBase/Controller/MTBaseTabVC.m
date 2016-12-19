//
//  MTBaseTabVC.m
//  rrmj
//
//  Created by MenThu on 2016/12/8.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseTabVC.h"
#import "MTBaseNavigationVC.h"
#import "HomePageVC.h"

@interface MTBaseTabVC ()
{
    UITabBarItem *_scaleTarbarItem;
    NSUInteger _lastSelectTag;
}

@end

@implementation MTBaseTabVC

+ (void)initialize{
    UITabBar *tarBar = [UITabBar appearance];
    tarBar.translucent = NO;
    [tarBar setBarTintColor:[UIColor colorWithHexString:@"#2e313c"]];
    
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#00abdc"]} forState:UIControlStateSelected];
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#93979f"],NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomePageVC *homePage = [[HomePageVC alloc] init];
    [self addModel:homePage normalImage:@"01_dark" selectImage:@"01_light" tarbarItemName:@"首页"];
    
    UIViewController *homePage1 = [[UIViewController alloc] init];
    [self addModel:homePage1 normalImage:@"02_dark" selectImage:@"02_light" tarbarItemName:@"订阅"];
    
    UIViewController *homePage2 = [[UIViewController alloc] init];
    [self addModel:homePage2 normalImage:@"03_dark" selectImage:@"03_light" tarbarItemName:@"发现"];
    
    UIViewController *homePage3 = [[UIViewController alloc] init];
    [self addModel:homePage3 normalImage:@"04_dark" selectImage:@"04_light" tarbarItemName:@"我的"];
}


- (void)addModel:(UIViewController *)viewController normalImage:(NSString *)normal selectImage:(NSString *)select tarbarItemName:(NSString *)name{
    CGSize imageSize = CGSizeMake(20, 20);
    MTBaseNavigationVC *mtBaseNav = [[MTBaseNavigationVC alloc] initWithRootViewController:viewController];
    viewController.hidesBottomBarWhenPushed = NO;
    mtBaseNav.tabBarItem.image = [[[UIImage imageNamed:normal] scaleImage:imageSize] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mtBaseNav.tabBarItem.selectedImage = [[[UIImage imageNamed:select] scaleImage:imageSize] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mtBaseNav.tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
    mtBaseNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    mtBaseNav.tabBarItem.title = name;
    [self addChildViewController:mtBaseNav];
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
