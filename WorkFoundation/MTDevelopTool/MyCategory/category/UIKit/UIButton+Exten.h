//
//  UIButton+Exten.h
//  UIButton+Exten
//
//  Created by MenThu on 2018/1/24.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonDisplayMode) {
    ButtonDisplayModeImgLeftTextRight = 0,
    ButtonDisplayModeImgRightTextLeft,
    ButtonDisplayModeImgUpTextBottom,
    ButtonDisplayModeImgBottomTextUp,
};

@interface UIButton (Exten)

/**
 *  在UIButton的Size是符合预期的时候，调用此方法
 *  imgTextSpace是titleLabel与ImageView之间的距离
 *  当mode=ButtonDisplayModeImgLeftTextRight或者ButtonDisplayModeImgRightTextLeft时，imgTextSpace指的是水平距离
 *  当mode=ButtonDisplayModeImgUpTextBottom或者ButtonDisplayModeImgBottomTextUp时，imgTextSpace指的是竖直距离
 */
- (void)adjustImgTextPosition:(ButtonDisplayMode)mode space:(CGFloat)imgTextSpace;

@end
