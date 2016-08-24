//
//  AwesomePickerView.m
//  TestPicker
//
//  Created by MenThu on 16/8/19.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "AwesomePickerView.h"

@interface AwesomePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>


@property (strong, nonatomic) UIPickerView *pickerView;
//选择器高度
@property (nonatomic, assign) CGFloat pickerViewHeight;
//选择器列
@property (nonatomic, assign) NSInteger pickColumn;

@property (nonatomic, assign) CGFloat  screenWidth;

@property (nonatomic, assign) BOOL  isShow;

//标题选择栏高度
@property (nonatomic, assign) CGFloat titleViewHeight;

@property (nonatomic, strong) UIView *titleView;


@property (nonatomic, strong) NSMutableArray<NSArray <ItemModel *> *> *pickerReloadSource;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectIndexArray;






@end

@implementation AwesomePickerView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self viewConfigWithFrame:frame];
    }
    return self;
}


- (void)viewConfigWithFrame:(CGRect)frame
{
    
    
    CGFloat fatherViewWidth = frame.size.width;
    CGFloat fatherViewHeight = frame.size.height;
    
    self.pickerViewHeight = 216.f;
    self.titleViewHeight = 50.f;
    
    
    CGFloat originTitleViewY = fatherViewHeight - self.pickerViewHeight - self.titleViewHeight;
    CGFloat originPickerY = fatherViewHeight - self.pickerViewHeight;
    
    MJWeakSelf;
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickBtn:)];
    [self addGestureRecognizer:viewTap];
    self.backgroundColor = JZColor(0, 0, 0, 0.5);
    
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = JZColor(236, 236, 236, 1);
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:JZColor(44, 91, 255, 1) forState:UIControlStateNormal];
    cancelBtn.tag = 0;
    cancelBtn.adjustsImageWhenHighlighted = NO;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"选择学校";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:JZColor(44, 91, 255, 1) forState:UIControlStateNormal];
    confirmBtn.tag = 1;
    confirmBtn.adjustsImageWhenHighlighted = NO;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmBtn addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [titleView addSubview:cancelBtn];
    [titleView addSubview:titleLabel];
    [titleView addSubview:confirmBtn];
    
    
    
    
    //    [cancelBtn setFrame:CGRectMake(0, 0, fatherViewWidth*0.25, self.titleViewHeight)];
    //    [titleLabel setFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame), 0, fatherViewWidth*0.5, self.titleViewHeight)];
    //    [confirmBtn setFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, fatherViewWidth*0.25, self.titleViewHeight)];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView);
        make.left.equalTo(titleView);
        make.bottom.equalTo(titleView);
        make.right.equalTo(titleLabel.mas_left);
        
        make.width.equalTo(confirmBtn);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView);
        make.bottom.equalTo(titleView);
        make.right.equalTo(confirmBtn.mas_left);
        
        make.width.mas_equalTo(fatherViewWidth*0.5);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView);
        make.bottom.equalTo(titleView);
        make.right.equalTo(titleView);
    }];
    
    
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.isShow = NO;
    
    self.titleView = titleView;
    [self addSubview:titleView];
    [self addSubview:self.pickerView];
    
    [titleView setFrame:CGRectMake(0, originTitleViewY, fatherViewWidth, self.titleViewHeight)];
    [self.pickerView setFrame:CGRectMake(0, originPickerY, fatherViewWidth, self.pickerViewHeight)];
    
    
    //    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(weakSelf.pickerView.mas_top);
    //        make.centerX.equalTo(weakSelf);
    //        make.width.mas_equalTo(fatherViewWidth);
    //        make.height.mas_equalTo(weakSelf.titleViewHeight);
    //    }];
    
    
    //
    //    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(weakSelf);
    //        make.right.equalTo(weakSelf);
    //        make.height.mas_equalTo(weakSelf.pickerViewHeight);
    //    }];
    //
    //    [self.pickerView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
    //    }];
    
}

- (void)setPickerSource:(NSArray <ItemModel *> *)pickerSource
{
    _pickerSource = pickerSource;
    
    
    self.pickerReloadSource = [NSMutableArray array];
    
    NSArray <ItemModel *> *itemNextArray = pickerSource;
    while (itemNextArray!=nil) {
        [self.pickerReloadSource addObject:itemNextArray];
        itemNextArray = itemNextArray[0].nextArray;
    }
    
    
    self.selectIndexArray = [NSMutableArray array];
    self.pickColumn = [self findMaxCountArray:pickerSource];
    [self.pickerView reloadAllComponents];
    
    //默认选择第一行
    for (NSInteger index = 0; index < self.pickColumn; index ++) {
        [self.selectIndexArray addObject:@(0)];
    }
    
    
}

- (void)prepareForPickerWithStartIndex:(NSInteger)start startRow:(NSInteger)row
{
    [self.selectIndexArray replaceObjectAtIndex:start withObject:@(row)];
    NSIndexSet *deleteSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(start+1, self.pickerReloadSource.count-1-start)];
    [self.pickerReloadSource removeObjectsAtIndexes:deleteSet];
    
    NSArray <ItemModel *> *itemNextArray = self.pickerReloadSource[start][row].nextArray;
    while (itemNextArray!=nil) {
        [self.pickerReloadSource addObject:itemNextArray];
        itemNextArray = itemNextArray[0].nextArray;
    }
    for (NSInteger index = start+1; index < self.pickColumn; index++) {
        [self.pickerView reloadComponent:index];
        [self.pickerView selectRow:0 inComponent:index animated:YES];
        [self.selectIndexArray replaceObjectAtIndex:index withObject:@(0)];
    }
}

- (NSInteger)findMaxCountArray:(NSArray *)pickSource
{
    NSInteger maxCount = 1;
    for (ItemModel *model in pickSource) {
        NSInteger thisItemCount = 1;
        if (model.nextArray == nil) {
            //此节点终止
            if (maxCount < thisItemCount) {
                maxCount = thisItemCount;
            }
            continue;
        }else{
            thisItemCount += [self findMaxCountArray:model.nextArray];
            if (thisItemCount > maxCount) {
                maxCount = thisItemCount;
            }
        }
    }
    return maxCount;
}


#pragma mark - UIPickerView的代理及数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.pickColumn;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerReloadSource.count-1 >= component) {
        return [self.pickerReloadSource objectAtIndex:component].count;
    }else{
        return 0;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [[self.pickerReloadSource objectAtIndex:component] objectAtIndex:row].itemName;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    return titleLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.screenWidth/self.pickColumn;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self prepareForPickerWithStartIndex:component startRow:row];
}

- (void)ClickBtn:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        if (btn.tag == 1) {
            //确定
            [self dismissViewWithRezult:self.selectIndexArray];
        }else{
            //取消
            [self dismissViewWithRezult:nil];
        }
    }else{
        //取消
        [self dismissViewWithRezult:nil];
    }
}

- (void)showFromView:(UIView *)fatherView
{
    self.isShow = YES;
    [fatherView addSubview:self];
    
    
    [self.titleView setFrame:CGRectMake(0, CGRectGetMaxY(self.frame), self.width, self.titleViewHeight)];
    [self.pickerView setFrame:CGRectMake(0, CGRectGetMaxY(self.frame)+self.titleViewHeight, self.width, self.pickerViewHeight)];
    [UIView animateWithDuration:GlobalAnimateTime animations:^{
        [self.titleView setFrame:CGRectMake(0, CGRectGetMaxY(self.frame)-self.pickerViewHeight-self.titleViewHeight, self.width, self.titleViewHeight)];
        [self.pickerView setFrame:CGRectMake(0, CGRectGetMaxY(self.frame)-self.pickerViewHeight, self.width, self.pickerViewHeight)];
    }];
}

- (void)dismissViewWithRezult:(NSMutableArray *)rezultArray
{
    [UIView animateWithDuration:GlobalAnimateTime animations:^{
        [self.titleView setFrame:CGRectMake(0, CGRectGetMaxY(self.frame), self.width, self.titleViewHeight)];
        [self.pickerView setFrame:CGRectMake(0, CGRectGetMaxY(self.frame)+self.titleViewHeight, self.width, self.pickerViewHeight)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.finishBlock) {
            self.finishBlock(rezultArray);
        }
    }];
}


@end
