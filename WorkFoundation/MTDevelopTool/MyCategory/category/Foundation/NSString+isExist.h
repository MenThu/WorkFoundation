//
//  NSString+isExist.h
//  TestGitHub
//
//  Created by MenThu on 16/7/20.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (isExist)

/**
 *  检查NSString是否为有效字符串
 **/
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

+ (NSString *)convertTime:(float)second;

/**
 *
 *  计算字符串高度宽度
 *
 **/
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;
- (CGFloat)widthForFont:(UIFont *)font;
- (CGSize)sizeForFont:(UIFont *)font
                 size:(CGSize)size
                 mode:(NSLineBreakMode)lineBreakMode;

/**
 *  检查字符串是否为电话号码
 **/
- (BOOL)isPhoneExist;

/**
 *  拨打电话
 **/
- (void)makeCall;

/**
 *  时间转机器时间,单位秒(时间格式YYYY-MM-dd HH:mm:ss)
 **/
- (NSTimeInterval)conver2TimeInterval;

/**
 *  是否为整数
 **/
- (BOOL)isPureInt;

@end
