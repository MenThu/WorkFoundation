//
//  UIColor+Extension.h
//  rrmj
//
//  Created by MenThu on 2016/12/8.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/**
 *  以十六进制数字生成颜色
 **/
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
