//
//  PageControlView.m
//  rrmjMT
//
//  Created by MenThu on 2016/12/20.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTPageControlView.h"

@interface MTPageControlView ()

@end

@implementation MTPageControlView


- (void)customView{
    _pageView = [[UIPageControl alloc] init];
    [self addSubview:_pageView];
    _pageView.pageIndicatorTintColor = [UIColor colorWithHexString:@"#858784"];
    _pageView.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#00b4f4"];
    @weakify(self);
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-5);
        make.height.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
    }];
}

- (void)setPageCount:(NSInteger)pageCount{
    _pageView.numberOfPages = pageCount;
    _pageView.currentPage = 0;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.pageView.hidden =  !self.isPageControlShow;
}

- (void)scrollView:(UICollectionView *)collectionView{
    //滚动
    //四舍五入
    if (self.isPageControlShow) {
        self.pageView.currentPage = (int)((collectionView.contentOffset.x / collectionView.width) + 0.5) % self.pageView.numberOfPages;
    }
}

@end
