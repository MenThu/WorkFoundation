//
//  AwesomePickerView.h
//  TestPicker
//
//  Created by MenThu on 16/8/19.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"

typedef void(^FinishSelect)(NSArray <NSNumber *> *selectArray);

@interface AwesomePickerView : UIView

+ (instancetype)loadThisView;

@property (nonatomic, strong) NSArray <ItemModel *> *pickerSource;
@property (nonatomic, copy) FinishSelect finishBlock;

@end
