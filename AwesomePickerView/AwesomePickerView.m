//
//  AwesomePickerView.m
//  TestPicker
//
//  Created by MenThu on 16/8/19.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "AwesomePickerView.h"

@interface AwesomePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>


@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray<NSArray <ItemModel *> *> *pickerReloadSource;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectIndexArray;

//选择器列
@property (nonatomic, assign) NSInteger pickColumn;

@property (nonatomic, assign) CGFloat  screenWidth;

@end

@implementation AwesomePickerView

+ (instancetype)loadThisView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil].firstObject;
}

- (void)awakeFromNib
{
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
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


- (IBAction)ClickBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        //确定
        if (self.finishBlock) {
            self.finishBlock(self.selectIndexArray);
        }
    }else{
        //取消
        if (self.finishBlock) {
            self.finishBlock(nil);
        }
    }
}



@end
