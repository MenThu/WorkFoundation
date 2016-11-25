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

#define isGCD_On 0

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
    _isHaveGif = YES;
    _gifPath = gifPath;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL * url = [[NSURL alloc] initFileURLWithPath:[mainBundle pathForResource:_gifPath ofType:nil]];
    
    @weakify(self);
    [UIImage analyzeGif2UIImage:url returnData:^(NSArray<UIImage *> *imageArray, NSArray<NSNumber *> *timeArray, NSArray<NSNumber *> *widths, NSArray<NSNumber *> *heights, CGFloat totalTime) {
        @strongify(self);
        _gifTime = totalTime;
        self.gifArray = imageArray;
    }];
}

- (void)setGifArray:(NSArray<UIImage *> *)gifArray{
    _gifArray = gifArray;
    _isHaveGif = YES;
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
    
    if (!_isHaveGif){
        //普通的下拉刷新头部
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            _pageNo = 1;
            self.refreshBlock(_pageNo);
        }];
    }else{
        MTBaseGifHead *mj_header = [MTBaseGifHead headerWithRefreshingBlock:^{
            @strongify(self);
            _pageNo = startPageNo;
            self.refreshBlock(_pageNo);
        }];
        
        mj_header.gifTime = _gifTime * 0.5;
        
        if ([self.titleString isExist]) {
            mj_header.titleString = self.titleString;
        }
        NSLog(@"开始 : [%@]",[NSDate systemCurrentTime]);
        mj_header.iamgesArray = _gifArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [mj_header prepareMTGifHead];
            self.mj_header = mj_header;
            NSLog(@"更新主UI %@", [NSDate systemCurrentTime]);
        });
    }
}

- (void)endRefresh{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

@end
