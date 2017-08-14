//
//  MTPickerView.h
//  MTTest
//
//  Created by MenThu on 2017/5/2.
//  Copyright © 2017年 官辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTPickerModel.h"

@interface MTBasePickerView : UIView

@property (nonatomic, strong) MTPickerModel *model;

/**
 *  MTBasePickerView隐藏动画完成之后的block回调
 **/
@property (nonatomic, copy) void (^finishSelect) (NSArray <NSNumber *> *selectIndex);

- (void)showMTPicker;

- (void)hideMTPickerWithSelectIndex:(NSArray <NSNumber *> *)selectIndex;

@end
