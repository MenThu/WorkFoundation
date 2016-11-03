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
    ImageBottom,//图片在下面
    TitleCenter //图片和btn的Frame一样，然后title在Btn中间
} ButtomStyle;

@interface UIButton (Custom)

- (void)buttonDisplayStyle:(ButtomStyle)buttomStyle;

@end
