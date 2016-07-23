//
//  AutoTableView.h
//  TestGitHub
//
//  Created by MenThu on 16/7/23.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKitMacro.h"



FOUNDATION_EXTERN NSInteger const FirstPageNo;

/**
 *  下拉刷新界面Block
 */
typedef void(^DownRefresh)(NSInteger pageNo);

/**
 *  上拉加载界面Block
 */
typedef void(^UpRefresh)(NSInteger pageNo);

@interface AutoTableView : UITableView

@property (nonatomic, copy) DownRefresh downBlock;
@property (nonatomic, copy) UpRefresh upBlock;

@property (nonatomic, assign, readonly) NSInteger  pageNo;

@end
