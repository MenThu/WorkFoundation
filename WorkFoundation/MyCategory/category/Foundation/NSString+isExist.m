//
//  NSString+isExist.m
//  TestGitHub
//
//  Created by MenThu on 16/7/20.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "NSString+isExist.h"

@implementation NSString (isExist)

- (BOOL)isExist
{
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0;
}


- (CGFloat)widthWithFont:(UIFont *)font limitHeight:(CGFloat)height{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.width;
}

- (CGFloat)heightWithFont:(UIFont *)font limitWidth:(CGFloat)width{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    return [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
}

+ (NSString *)getStringWithWidth:(CGFloat)stringMaxWidth inFont:(UIFont *)font{
    NSMutableArray *shuffledAlphabet = [NSMutableArray arrayWithArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]];
    NSMutableString *string = [NSMutableString string];
    float strWidth = 0;
    while (strWidth < stringMaxWidth) {
        [string appendString:shuffledAlphabet[arc4random() % shuffledAlphabet.count]];
        strWidth = [string widthForFont:font];
    }
    [string deleteCharactersInRange:NSMakeRange(string.length-1, 1)];
    return string;
}

- (NSAttributedString *)lineSpace:(CGFloat)lineSpace strFont:(UIFont *)font limitWidth:(CGFloat)width strNeedHeight:(CGFloat *)height{
    NSAttributedString *attrString = nil;
    NSDictionary *dic = nil;
    //查看string是否有一行以上
    BOOL isMoreThanOneLine = ([self heightForFont:font width:width] > font.lineHeight ? YES : NO);
    if (!isMoreThanOneLine) {
        dic = @{NSFontAttributeName:font};
        attrString = [[NSAttributedString alloc] initWithString:self attributes:dic];
        if (height) {
            *height = font.lineHeight;
        }
    }else{
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineSpacing = lineSpace; //设置行间距
        paraStyle.hyphenationFactor = 1.0;
        paraStyle.firstLineHeadIndent = 0.0;
        paraStyle.paragraphSpacingBefore = 0.0;
        paraStyle.headIndent = 0;
        paraStyle.tailIndent = 0;
        dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(0.2)};
        attrString = [[NSAttributedString alloc] initWithString:self attributes:dic];
        if (height) {
            *height = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
        }
    }
    return attrString;
}

+ (NSString *)convertTime:(float)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    if (second/3600 >= 1) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"mm:ss"];
    }
    return [dateFormatter stringFromDate:d];
}

@end
