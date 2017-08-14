//
//  MTBaseTableVC.h
//  rrmjMT
//
//  Created by MenThu on 2016/12/12.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseVC.h"
#import "MTBaseCellModel.h"

FOUNDATION_EXTERN NSString *const mtBaseTableControllerCell;

@interface MTBaseTableVC : MTBaseVC

/**
 *  table的数据源
 **/
@property (nonatomic, strong) NSArray <MTBaseCellModel *> *tableSource;

/**
 *  基类的tableView
 **/
@property (nonatomic, readonly) UITableView *mtBaseTableView;

/**
 *  tableview距离self.view的四边边距[默认 0,0,0,0]
 **/
@property (nonatomic, strong) NSArray <NSNumber *> *baseTableMargin;

/**
 *  tableView的风格是否为plain[默认yes]
 **/
@property (nonatomic, assign) BOOL isStylePlain;

/**
 *  子类cell的类名
 **/
@property (nonatomic, copy) NSString *cellClassName;

/**
 *  是否来自于xib【默认为yes】
 **/
@property (nonatomic, assign) BOOL isFromXib;

/**
 *  下拉刷新的block
 **/
@property (nonatomic, copy) void (^refreshBlock) (NSInteger pageNo);

/**
 *  上拉加载的block
 **/
@property (nonatomic, copy) void (^loadMore) (NSInteger pageNo);

/**
 *  下拉刷新的起始页数[默认为1]
 **/
@property (nonatomic, assign) NSInteger requeStartPageNo;

/**
 *  子类自定义初始化上述变量的入口
 **/
- (void)initVaribles;

/**
 *  停止刷新[子类应该调用最先调用[super endTableRefresh]]
 **/
- (void)endTableRefresh;

/**
 *  基类已经默认实现
 *  子类可以覆盖方法来自定义
 *  后期需要增加
 *  下拉动态图[基于MJRefresh]
 *  MTBaseSectionHead [viewForHead]
 *  MTBaseSectionFoot [viewForFoot]
 *  统一的行为
 **/
- (NSInteger)sectionCountFor:(UITableView *)mtBaseTableview;
- (NSInteger)rowCountFor:(NSInteger)section mtBaseTable:(UITableView *)tableView;
- (MTBaseCell *)cellForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (CGFloat)heightFor:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

/**
    ScrollView滚动的代理
 **/
- (void)scrollViewMove:(CGPoint)contentOffset view:(UITableView *)tableView;


@end
