//
//  MTBaseVC.m
//  rrmjMT
//
//  Created by MenThu on 2016/12/9.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseVC.h"

@interface MTBaseVC ()

@property (nonatomic, strong) UIImageView *waitFotHttp;

@end

@implementation MTBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //父类的初始化工作
    [self initialWorkendBlock:^{
        //子类自定义导航栏
        [self configNavigationItem];
        //子类的初始化工作
        [self configView];
        //子类的网络请求
        [self startHttpRequest];
    }];
}

- (void)configNavigationItem{
    CGFloat right = self.item2ScreenSpace[1].floatValue;
    CGFloat left = self.item2ScreenSpace[0].floatValue;
    if (self.navigationItem.rightBarButtonItem && fabs(right) > 0) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = right;
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, self.navigationItem.rightBarButtonItem];
    }
    
    if (self.navigationItem.leftBarButtonItem && fabs(left) > 0) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = left;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, self.navigationItem.leftBarButtonItem];
    }
}

- (void)configView{

}

- (void)startHttpRequest{
    [self.waitFotHttp startAnimating];
    if (self.contentView && self.contentView.superview && [self.contentView respondsToSelector:@selector(setHidden:)]) {
        self.contentView.hidden = YES;
    }
}

- (void)endHttpRequest{
    [self.waitFotHttp stopAnimating];
    if ([self.contentView respondsToSelector:@selector(setHidden:)]) {
        self.contentView.hidden = NO;
    }
}

#pragma mark - 私有方法
- (void)initialWorkendBlock:(void(^)(void))endBlock{
    MTWeakSelf;
    self.item2ScreenSpace = @[@(0),@(0)];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    self.waitFotHttp = [[UIImageView alloc] init];
    self.waitFotHttp.contentMode = UIViewContentModeScaleAspectFit;
    self.waitFotHttp.tag = 1;
    [self.view addSubview:self.waitFotHttp];
    [self.waitFotHttp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    //添加动态动画图片
//    [UIImage analyzeGif2UIImage:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"httpHold.gif" ofType:nil]] returnData:^(NSArray<UIImage *> *imageArray, NSArray<NSNumber *> *timeArray, NSArray<NSNumber *> *widths, NSArray<NSNumber *> *heights, CGFloat totalTime) {
//        weakSelf.waitFotHttp.animationImages = imageArray;
//        weakSelf.waitFotHttp.animationDuration = 2.f;
//        endBlock();
//    }];
    endBlock();
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"[%@] MemoryWarning",NSStringFromClass([self class]));
}

@end
