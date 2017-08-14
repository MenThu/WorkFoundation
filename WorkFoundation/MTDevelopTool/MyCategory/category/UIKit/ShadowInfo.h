//
//  ShadowInfo.h
//  artapp
//
//  Created by MenThu on 2017/5/6.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShadowInfo : NSObject
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, copy) NSString *colorHexStr;
@property (nonatomic, assign) CGFloat Opacity;
@end
