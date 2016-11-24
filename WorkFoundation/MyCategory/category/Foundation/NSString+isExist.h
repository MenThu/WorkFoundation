//
//  NSString+isExist.h
//  TestGitHub
//
//  Created by MenThu on 16/7/20.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (isExist)

- (BOOL)isExist;


/**
 *  根据字体 高度，计算字体所需宽度
 *  font    :   字体
 *  height  :   字体限定高度
 **/
- (CGFloat)widthWithFont:(UIFont *)font limitHeight:(CGFloat)height;

/**
 *  根据字体，限定宽度计算字体所需高度
 *  font    :   字体
 *  width   :   字体限定宽度
 **/
- (CGFloat)heightWithFont:(UIFont *)font limitWidth:(CGFloat)width;

@end
