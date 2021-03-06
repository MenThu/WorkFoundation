//
//  MTDatePickerView.h
//  MTTest
//
//  Created by MenThu on 2017/5/3.
//  Copyright © 2017年 官辉. All rights reserved.
//

#import "MTBasePickerView.h"
#import "MTTimerManager.h"

@interface MTDatePickerView : MTBasePickerView

- (instancetype)initWithFrame:(CGRect)frame finish:(void (^) (MTTimeObject *timeObject))finishBlock;

@end
