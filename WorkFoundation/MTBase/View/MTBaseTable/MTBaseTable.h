//
//  MTBaseTable.h
//  TestStoryboard
//
//  Created by MenThu on 2016/11/21.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTBaseCell.h"
#import "MTBaseCellModel.h"

@interface MTBaseTable : UITableView <UITableViewDataSource,UITableViewDelegate>

/**
 gifPath
 或者
 gifArray gifTime 二者选其一
 **/
@property (nonatomic,copy)NSString *gifPath;

@property (nonatomic,strong)NSArray <UIImage *> *gifArray;

@property (nonatomic, assign) CGFloat gifTime;

/**
 cell重用的字符串
 **/
@property (nonatomic, copy) NSString *cellClassName;

/**
 cell是否来自于xib，默认为YES
 **/
@property (nonatomic, assign) BOOL isFromNib;

/**
 titleString 下拉刷新的提示文字
 **/
@property (nonatomic, copy) NSString *titleString;

/**
 下拉刷新
 **/
@property (nonatomic, copy) void (^refreshBlock)(NSInteger pageNo);

/**
 数据源
 **/
@property (nonatomic, weak) NSArray <MTBaseCellModel *> *tableSource;

/**
 UITableView滚动的代理
 **/
@property (nonatomic, copy) void (^viewDidScroll) (MTBaseTable *scrollView, CGFloat currentOffsetY, BOOL isDragDown);

/**
 变量设置完成告诉table去做初始化操作[调用一次]
 **/
- (void)prepareTable;

/**
 结束刷新
 **/
- (void)endRefresh;




@end
