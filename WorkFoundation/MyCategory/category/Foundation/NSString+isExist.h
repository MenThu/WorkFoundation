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


/**
    在规定的字体下，生成最接近要求宽度的字符串（字符串宽度 < stringMaxWidth）
 **/
+ (NSString *)getStringWithWidth:(CGFloat)stringMaxWidth inFont:(UIFont *)font;


/**
    根据要求生成一个富文本
    lineSpace   :   行间距
    font        :   字体大小
    width       :   限制宽度
    height      :   所占宽度(输出参数)
 **/
- (NSAttributedString *)lineSpace:(CGFloat)lineSpace strFont:(UIFont *)font limitWidth:(CGFloat)width strNeedHeight:(CGFloat *)height;

@end
