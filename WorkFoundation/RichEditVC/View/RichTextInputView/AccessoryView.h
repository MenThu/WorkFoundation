//
//  accessoryView.h
//  CGLearn
//
//  Created by MenThu on 16/6/30.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHead.h"

@interface AccessoryView : UIView

+ (instancetype)loadView;

@property (copy, nonatomic)IsAddImageOrPhoto block;

@end
