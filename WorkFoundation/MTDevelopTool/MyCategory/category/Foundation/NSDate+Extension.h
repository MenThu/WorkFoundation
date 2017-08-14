//
//  NSDate+Extension.h
//  TestStoryboard
//
//  Created by MenThu on 2016/11/24.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
  * 根据格式生成系统时间
  * 返回的时间格式 默认为 YYYY/MM/dd hh:mm:ss SS"
 **/
+ (NSString *)systemCurrentTime;

@end
