//
//  PageControlView.h
//  rrmjMT
//
//  Created by MenThu on 2016/12/20.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseCollectionView.h"

@interface MTPageControlView : MTBaseCollectionView


@property (nonatomic, strong) UIPageControl *pageView;

@property (nonatomic, assign) BOOL isPageControlShow;

//设置PageControl的个数
- (void)setPageCount:(NSInteger)pageCount;

@end
