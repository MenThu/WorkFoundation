//
//  UITableViewRowAction+Image.h
//  TestStoryboard
//
//  Created by MenThu on 2016/11/28.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewRowAction (Image)

@property (nonatomic, strong, nullable) UIImage *image;

@property (nonatomic, assign,nullable) NSNumber *index;

@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, assign) CGFloat imageWidth;

+ (nonnull instancetype)rowActionWithStyle:(UITableViewRowActionStyle)style image:(nullable UIImage *)image imageWidth:(CGFloat)width handler:(nullable void (^)(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath))handler;

@end
