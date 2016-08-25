//
//  UIButton+Custom.h
//  TestCocoapod
//
//  Created by MenThu on 16/8/23.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ImageRight,//图片在左边
    ImageUp, //图片在上面
    ImageBottom,
} ButtomStyle;

@interface UIButton (Custom)

- (void)buttonDisplayStyle:(ButtomStyle)buttomStyle;

@end
