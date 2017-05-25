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

- (BOOL)isPhoneExist{
    NSString *phoneNum = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phoneNum.length != 11){
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:phoneNum];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:phoneNum];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:phoneNum];
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)makeCall{
    NSMutableString *phoneUrlScheme = [[NSMutableString alloc] initWithFormat:@"tel:%@",self];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneUrlScheme] options:@{} completionHandler:^(BOOL success) {
            if (success) {
                MyLog(@"yes");
            }else{
                MyLog(@"no");
            }
        }];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneUrlScheme]];
    }
}
#pragma clang diagnostic pop

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


- (CGFloat)widthForFont:(UIFont *)font {
    CGSize size = [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}


- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (NSTimeInterval)conver2TimeInterval{
    NSString* timeStr = self;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-M-d HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:timeStr];
    NSTimeInterval dateFrom1970 = [date timeIntervalSince1970];
    return dateFrom1970;
}

- (BOOL)isPureInt{
    if (![self isExist]) {
        return NO;
    }
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

@end
