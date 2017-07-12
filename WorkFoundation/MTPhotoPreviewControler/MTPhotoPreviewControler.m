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

@end

@implementation MTPhotoPreviewControler

- (void)initVariable{
    self.isScrollDirectionHorizon = NO;
    self.itemWidth = MTScreenSize().width;
    //减去导航栏的高度
    self.itemHeight = MTScreenSize().height - 64.f;
    self.cellClassName = @"MTPhotoPreviewCell";
    self.isFromXib = NO;
}

- (void)configView{
    [super configView];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.pagingEnabled = YES;
}

- (void)setPhotoArray:(NSArray<MTPhotoPreviewModel *> *)photoArray{
    _photoArray = photoArray;
    self.collectionViewSource = photoArray;
}

- (void)showFromViewController:(UIViewController *)viewController{
    MTBaseNavigationVC *photoNavi = [[MTBaseNavigationVC alloc] initWithRootViewController:self];
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
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
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
