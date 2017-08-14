//
//  MTPhotoPreviewControler.m
//  artapp
//
//  Created by MenThu on 17/7/11.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "MTPhotoPreviewControler.h"
#import "MTPhotoPreviewCell.h"

@interface MTPhotoPreviewControler ()

@property (nonatomic, weak) UILabel *indexLabel;
@property (nonatomic, assign) CGFloat animateTime;
@property (nonatomic, copy) NSString *total;

@end

@implementation MTPhotoPreviewControler

+ (void)initialize{
    NSMutableDictionary*dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    UINavigationBar *navibar = [UINavigationBar appearance];
    [navibar setTitleTextAttributes:dict];
    [navibar setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    [barItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    [barItem setTintColor:[UIColor whiteColor]];
}

- (void)configNavigationItem{
    self.navigationItem.title = @"照片查看器";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    UIColor *alphaColor = MTColor(0, 0, 0, 0.7);
    UIImage *navibarImage = [UIImage imageWithColor:alphaColor];
    [self.navigationController.navigationBar setBackgroundImage:navibarImage forBarMetrics:UIBarMetricsDefault];
    [super configNavigationItem];
}

- (void)initVariable{
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.isScrollDirectionHorizon = self.scrollDirection;
    self.itemWidth = MTScreenSize().width;
    //减去导航栏的高度
    self.itemHeight = MTScreenSize().height;
    self.cellClassName = @"MTPhotoPreviewCell";
    self.isFromXib = NO;
    self.animateTime = 0.3f;
}

- (void)configView{
    [super configView];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.pagingEnabled = YES;
    UILabel *indexLabel = [UILabel new];
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.backgroundColor = MTColor(0, 0, 0, 0.5);
    indexLabel.font = [UIFont systemFontOfSize:17];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat indexLabelHeight = 50.f;
    indexLabel.frame = CGRectMake(0, MTScreenSize().height-indexLabelHeight, MTScreenSize().width, indexLabelHeight);
    [self.view addSubview:(_indexLabel = indexLabel)];
    
    self.total = [NSString stringWithFormat:@"%@", @(self.photoArray.count)];
    self.collectionViewSource = (NSMutableArray *)self.photoArray;
    self.indexLabel.text = [NSString stringWithFormat:@"1/%@", @(self.photoArray.count)];
}

- (void)showFromViewController:(UIViewController *)viewController{
    UINavigationController *photoNavi = [[UINavigationController alloc] initWithRootViewController:self];
    [viewController presentViewController:photoNavi animated:YES completion:nil];
}

- (void)dismiss{
    UIViewController *viewController = self;
    if ([self.navigationController isKindOfClass:[UINavigationController class]]) {
        viewController = self.navigationController;
    }
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)hiddenNavibar{
    MTWeakSelf;
    BOOL isHidden = !self.navigationController.navigationBar.hidden;
    [self.navigationController setNavigationBarHidden:isHidden animated:YES];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    [[UIApplication sharedApplication] setStatusBarHidden:isHidden withAnimation:UIStatusBarAnimationSlide];
#pragma clang diagnostic pop
    if (isHidden) {
        [UIView animateWithDuration:self.animateTime animations:^{
            weakSelf.indexLabel.y = weakSelf.view.height;
        }];
    }else{
        [UIView animateWithDuration:self.animateTime animations:^{
            weakSelf.indexLabel.y = weakSelf.view.height-weakSelf.indexLabel.height;
        }];
    }
}

- (void)scrollViewMove:(CGPoint)contentOffset view:(UICollectionView *)scrollView{
    CGFloat onePageLength = (self.isScrollDirectionHorizon == YES ? self.collectionView.width : self.collectionView.height);
    CGFloat offset = (self.isScrollDirectionHorizon == YES ? contentOffset.x : contentOffset.y);
    NSInteger currentIndex = (NSInteger)((offset / onePageLength) + 0.5) + 1;
    currentIndex = MAX(1, currentIndex);
    currentIndex = MIN(self.photoArray.count, currentIndex);
    self.indexLabel.text = [NSString stringWithFormat:@"%@/%@", @(currentIndex), self.total];
}

- (MTBaseCollectionCell *)cellForIndexPath:(NSIndexPath *)indexPath view:(UICollectionView *)collectionView{
    MTWeakSelf;
    MTBaseCollectionCell *cell = [super cellForIndexPath:indexPath view:collectionView];
    MTPhotoPreviewCell *previewCell = (MTPhotoPreviewCell *)cell;
    previewCell.singleTapCell = ^(){
        [weakSelf hiddenNavibar];
    };
    return previewCell;
}

@end
