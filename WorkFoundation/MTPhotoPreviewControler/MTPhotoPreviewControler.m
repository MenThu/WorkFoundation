//
//  MTPhotoPreviewControler.m
//  artapp
//
//  Created by MenThu on 17/7/11.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "MTPhotoPreviewControler.h"

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

@end
