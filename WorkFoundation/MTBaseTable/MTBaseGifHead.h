//
//  MTBaseGifHead.h
//  TestStoryboard
//
//  Created by MenThu on 2016/11/23.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface MTBaseGifHead : MJRefreshStateHeader

@property (nonatomic, weak)NSArray <UIImage *> *iamgesArray;

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, assign) CGFloat gifTime;

//设置好所有变量后，告诉gifhead更新布局
- (void)prepareMTGifHead;

@end
