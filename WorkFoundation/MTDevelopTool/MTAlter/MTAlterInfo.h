//
//  MTAlterInfo.h
//  artapp
//
//  Created by MenThu on 17/5/24.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTAction.h"

@interface MTAlterInfo : NSObject

@property (nonatomic, copy) NSString *mtTitle;
@property (nonatomic, copy) NSString *mtMessage;
@property (nonatomic, assign) UIAlertControllerStyle style;
@property (nonatomic, strong) NSArray <MTAction *> *actionArray;

@end
