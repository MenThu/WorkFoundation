//
//  MTPickerView.m
//  MTTest
//
//  Created by MenThu on 2017/5/2.
//  Copyright © 2017年 官辉. All rights reserved.
//

#import "MTBasePickerView.h"

@interface MTBasePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

/**
 *  pickerView的底视图
 **/
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, assign) CGFloat contentHeight;

/**
 *  取消按钮
 **/
@property (nonatomic, weak) UIButton *cancelBtn;

/**
 *  中间的title
 **/
@property (nonatomic, weak) UILabel *pickerName;
@property (nonatomic, assign) CGFloat pickerNameHeight;

/**
 *  确定按钮
 **/
@property (nonatomic, weak) UIButton *confirmBtn;

/**
 *  选择器
 **/
@property (nonatomic, weak) UIPickerView *pickerView;
/**
 *  pickerView的列数
 **/
@property (nonatomic, assign) NSInteger pickerColumn;
/**
 *  pickerView的横向数据源
 **/
@property (nonatomic, strong) NSMutableArray <NSArray <ItemModel *> *> *pickerDisplaySource;
/**
 *  pickerView每一列选择的下标
 **/
@property (nonatomic, strong) NSMutableArray <NSNumber *> *selectIndexArray;

@end

@implementation MTBasePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configContView];
    }
    return self;
}

- (void)hideView:(UITapGestureRecognizer *)tapGes{
    [self hideMTPickerWithSelectIndex:nil];
}

- (void)configContView{
    //增加删除手势
    self.userInteractionEnabled = YES;
    self.backgroundColor = MTColor(0, 0, 0, 0.7);
    UITapGestureRecognizer *hideGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView:)];
    [self addGestureRecognizer:hideGes];
    
    //增加底部PickerView的视图
    self.contentHeight = 230.f;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, self.contentHeight)];
    contentView.backgroundColor = [UIColor orangeColor];
    [self addSubview:(_contentView = contentView)];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 0;
    cancelBtn.adjustsImageWhenHighlighted = NO;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:(_cancelBtn = cancelBtn)];
    
    //确定按钮
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn addTarget:self action:@selector(cancelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.tag = 1;
    confirmBtn.adjustsImageWhenHighlighted = NO;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:(_confirmBtn = confirmBtn)];
    
    //picerName
    UILabel *pickerName = [[UILabel alloc] init];
    pickerName.text = @"MTBasePickerView";
    pickerName.textAlignment = NSTextAlignmentCenter;
    pickerName.textColor = [UIColor blackColor];
    pickerName.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:(_pickerName = pickerName)];
    
    //pickerView
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [contentView addSubview:(_pickerView = pickerView)];
    
    //建立约束
    MTWeakSelf;
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(contentView);
        make.bottom.equalTo(pickerName);
        make.width.equalTo(confirmBtn);
    }];
    
    self.pickerNameHeight = 30.f;
    [pickerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(cancelBtn.mas_right);
        make.right.equalTo(confirmBtn.mas_left);
        make.width.equalTo(contentView).multipliedBy(0.6);
        make.height.mas_equalTo(weakSelf.pickerNameHeight);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(cancelBtn);
        make.left.equalTo(pickerName.mas_right);
        make.right.equalTo(contentView);
    }];
    
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pickerName.mas_bottom);
        make.left.right.bottom.equalTo(contentView);
    }];
}

- (void)cancelOrConfirm:(UIButton *)btn{
    NSArray <NSNumber *> *array = nil;
    if (btn.tag == 0) {
        //取消
    }else if (btn.tag == 1){
        //确定
        array = self.selectIndexArray;
    }
    [self hideMTPickerWithSelectIndex:array];
}

#pragma mark - 公开方法
- (void)showMTPicker{
    MTWeakSelf;
    self.contentView.frame = CGRectMake(0, self.height, self.width, self.contentHeight);
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.contentView.frame = CGRectMake(0, weakSelf.height-weakSelf.contentHeight, weakSelf.width, weakSelf.contentHeight);
    }];
}

- (void)hideMTPickerWithSelectIndex:(NSArray <NSNumber *> *)selectIndex{
    MTWeakSelf;
    self.contentView.frame = CGRectMake(0, self.height-self.contentHeight, self.width, self.contentHeight);
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.contentView.frame = CGRectMake(0, weakSelf.height, weakSelf.width, weakSelf.contentHeight);
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
        if (weakSelf.finishSelect) {
            weakSelf.finishSelect(selectIndex);
        }
    }];
}

- (void)setModel:(MTPickerModel *)model{
    _model = model;
    self.pickerName.text = _model.pickerTitle;
    //计算UIPickerView的列数
    self.pickerColumn = [self calculateMaxColumnWithModel:_model.pickerSource];
    
    //准备展示的数据
    NSArray <ItemModel *> *nextArray = _model.pickerSource;
    self.pickerDisplaySource = [NSMutableArray array];
    
    //初始化时，每列均默认选择第一行
    while ([nextArray isExist]) {
        [self.pickerDisplaySource addObject:nextArray];
        nextArray = nextArray[0].nextArray;
    }
    
    self.selectIndexArray = [NSMutableArray array];
    for (NSInteger index = 0; index < self.pickerColumn; index ++) {
        [self.selectIndexArray addObject:@(0)];
    }
    
    //重载所有列
    [self.pickerView reloadAllComponents];
}

/**
 *  根据数据源寻找PickerView的最大列
 **/
- (NSInteger)calculateMaxColumnWithModel:(NSArray <ItemModel *> *)pickerSource{
    if ([pickerSource isKindOfClass:[NSArray class]] && pickerSource.count > 0) {
        NSInteger max = 1;
        for (ItemModel *rowModel in pickerSource) {
            NSInteger count = 1;
            //列数+1
            count += [self calculateMaxColumnWithModel:rowModel.nextArray];
            max = MAX(max, count);
        }
        return max;
    }else{
        return 0;
    }
}


/**
 *  根据pickerView选择的情况，来重新准备数据
 *  从第1列第0行挪动到了第一列第1行，则需要替换掉第二列的数据([1,0].nextArray)
 **/
- (void)selectRow:(NSInteger)row inColumn:(NSInteger)column
{
    //更改那一列选择的Row
    [self.selectIndexArray replaceObjectAtIndex:column withObject:@(row)];
    
    //删除column的数据源
    NSInteger loc = column+1;
    NSInteger length = (self.pickerDisplaySource.count-1) - loc + 1;
    NSIndexSet *deleteSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(loc, length)];
    [self.pickerDisplaySource removeObjectsAtIndexes:deleteSet];
    
    //重新添加column+1开始的数据源
    NSArray <ItemModel *> *nextArray = self.pickerDisplaySource[column][row].nextArray;
    NSInteger temp = 1;
    while ([nextArray isExist]) {
        [self.pickerDisplaySource addObject:nextArray];
        //记录上一次的选择
        NSInteger lastSelectRow = self.selectIndexArray[column+temp].integerValue;
        if(lastSelectRow > nextArray.count-1){
            //新的列数据源并没有这么行，故默认选择新列的最后一行
            lastSelectRow = nextArray.count-1;
            self.selectIndexArray[column+temp] = @(lastSelectRow);
        }
        temp++;
        nextArray = nextArray[lastSelectRow].nextArray;
    }
    for (NSInteger index = column+1; index < self.pickerColumn; index++) {
        [self.pickerView reloadComponent:index];
    }
}


#pragma mark - UIPickerView的代理及数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.pickerColumn;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerDisplaySource[component].count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.pickerDisplaySource[component][row].itemName;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    return titleLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.width / self.pickerColumn;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self selectRow:row inColumn:component];
}


@end
