//
//  MTBaseTable.m
//  TestStoryboard
//
//  Created by MenThu on 2016/11/21.
//  Copyright © 2016年 MenThu. All rights reserved.
//



#import "MTBaseTable.h"
#import "MTBaseGifHead.h"

static NSString *cellID = @"cellId";
static NSString *headViewID = @"headId";
static NSInteger startPageNo = 1;

@interface MTBaseTable ()
{
    //tableview当前页数
    NSInteger _pageNo;
    BOOL _isHaveGif;
    CGFloat _totalTime;
}
@property (nonatomic, strong) NSMutableArray *gitStingArray;

@end

@implementation MTBaseTable

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUpTable];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self setUpTable];
    }
    return self;
}

- (void)setUpTable{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showsVerticalScrollIndicator = NO;
    _isHaveGif = NO;
    _pageNo = startPageNo;
}

- (void)setGifPath:(NSString *)gifPath{
    _gifPath = gifPath;
    NSBundle *mainBundle = [NSBundle mainBundle];
    @weakify(self);
    NSURL * url = [[NSURL alloc] initFileURLWithPath:[mainBundle pathForResource:_gifPath ofType:nil]];
    [UIImage analyzeGif2UIImage:url returnData:^(NSArray<UIImage *> *imageArray, NSArray<NSNumber *> *timeArray, NSArray<NSNumber *> *widths, NSArray<NSNumber *> *heights, CGFloat totalTime) {
        @strongify(self);
        self.gifArray = imageArray;
        _totalTime = totalTime;
    }];
}

- (void)setGifArray:(NSArray<UIImage *> *)gifArray{
    _isHaveGif = YES;
    NSMutableArray *tempArray = [NSMutableArray array];
    CGFloat height = MIN(120.f, gifArray.lastObject.size.height);
    CGFloat width = 0.f;
    
    CGFloat scale = gifArray.lastObject.size.width / gifArray.lastObject.size.height;
    for (UIImage *originNalImage in gifArray) {
        width = height * scale;
        [tempArray addObject:[originNalImage scaleImage:CGSizeMake(width, height)]];
    }
    _gifArray = [NSArray arrayWithArray:tempArray];
}

- (void)setRefreshBlock:(void (^)(NSInteger))refreshBlock{
    if (self.refreshBlock) {
        //不允许重复赋值refreshBlock
        return;
    }
    _refreshBlock = refreshBlock;
}

- (void)prepareTable{
    
    
    @weakify(self);
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        _pageNo ++;
        self.refreshBlock(_pageNo);
    }];
    
    if (_isHaveGif) {
        MTBaseGifHead *mj_header = [MTBaseGifHead headerWithRefreshingBlock:^{
            @strongify(self);
            _pageNo = startPageNo;
            self.refreshBlock(_pageNo);
        }];
        //设置刷新的头部动态视图
        mj_header.iamgesArray = _gifArray;
        mj_header.gifTime = 3;
        
        if ([self.titleString isExist]) {
            mj_header.titleString = self.titleString;
        }
        [mj_header prepareMTGifHead];
        self.mj_header = mj_header;
    }else{
        //普通的下拉刷新头部
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            _pageNo = 1;
            self.refreshBlock(_pageNo);
        }];
    }
}

- (void)endRefresh{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

@end
