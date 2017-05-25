//
//  MTAlterInfo.m
//  artapp
//
//  Created by MenThu on 17/5/24.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "MTAlterInfo.h"

@implementation MTAlterInfo

- (void)setActionArray:(NSArray<MTAction *> *)actionArray{
    NSMutableArray <MTAction *> *addActionArray = [NSMutableArray arrayWithArray:actionArray];
    MTAction *cancelAction = [MTAction new];
    cancelAction.mtActionTitle = @"取消";
    cancelAction.style = UIAlertActionStyleCancel;
    cancelAction.tapAction = nil;
    [addActionArray addObject:cancelAction];
    _actionArray = addActionArray;
}

@end
