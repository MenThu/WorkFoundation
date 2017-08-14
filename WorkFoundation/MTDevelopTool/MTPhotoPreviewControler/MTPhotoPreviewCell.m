//
//  MTPhotoPreviewCell.m
//  artapp
//
//  Created by MenThu on 17/7/11.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "MTPhotoPreviewCell.h"
#import "MTPhotoPreviewModel.h"

@interface MTPhotoPreviewCell () <UIGestureRecognizerDelegate,UIScrollViewDelegate> {
    CGFloat _aspectRatio;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *imageContainerView;

@end

@implementation MTPhotoPreviewCell

- (void)customView{
    [super customView];
    MTWeakSelf;
    self.contentView.backgroundColor = [UIColor blackColor];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bouncesZoom = YES;
    _scrollView.maximumZoomScale = 2.5;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.alwaysBounceVertical = NO;
    [self.contentView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
    
    _imageContainerView = [[UIView alloc] init];
    _imageContainerView.clipsToBounds = YES;
    [_scrollView addSubview:_imageContainerView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    _imageView.clipsToBounds = YES;
    [_imageContainerView addSubview:_imageView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self addGestureRecognizer:tap2];
}

- (void)updateCustomView{
    MTWeakSelf;
    MTPhotoPreviewModel *model = (MTPhotoPreviewModel *)self.cellModel;
    if (model.type == 0) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            weakSelf.imageView.image = image;
            [weakSelf resizeSubviews];
        }];
    }else{
        self.imageView.image = model.imgIcon;
        [self resizeSubviews];
    }
}

- (void)resizeSubviews {
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width = self.contentView.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.contentView.height / self.contentView.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.contentView.width));
    }else {
        CGFloat height = image.size.height / image.size.width * self.contentView.width;
        if (height < 1 || isnan(height)) height = self.contentView.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.contentView.height / 2;
    }
    if (_imageContainerView.height > self.contentView.height && _imageContainerView.height - self.contentView.height <= 1) {
        _imageContainerView.height = self.contentView.height;
    }
    _scrollView.contentSize = CGSizeMake(self.contentView.width, MAX(_imageContainerView.height, self.contentView.height));
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.contentView.height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}

#pragma mark - 单击、双击
- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapCell) {
        self.singleTapCell();
    }
}

#pragma mark - ScrollView的代理
#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.width > scrollView.contentSize.width) ? (scrollView.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.height > scrollView.contentSize.height) ? (scrollView.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}



@end
