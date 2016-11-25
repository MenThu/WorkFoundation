//
//  MTBaseTable.h
//  TestStoryboard
//
//  Created by MenThu on 2016/11/21.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTBaseCell.h"
#import "MTBaseModel.h"

@interface MTBaseTable : UITableView
/**
    gifPath 
        或者
    gifArray gifTime 二者选其一
 **/
@property (nonatomic,copy)NSString *gifPath;
@property (nonatomic,strong)NSArray <UIImage *> *gifArray;
@property (nonatomic, assign) CGFloat gifTime;
/**
    titleString 下拉刷新的提示文字
 **/
@property (nonatomic, copy) NSString *titleString;
/**
    下拉刷新
 **/
@property (nonatomic, copy) void (^refreshBlock)(NSInteger pageNo);
/**
    变量设置围城告诉table去做初始化操作[调用一次]
 **/
- (void)prepareTable;
/**
    结束刷新
 **/
- (void)endRefresh;
@end
