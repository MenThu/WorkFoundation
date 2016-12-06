//
//  UITableViewRowAction+Image.m
//  TestStoryboard
//
//  Created by MenThu on 2016/11/28.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "UITableViewRowAction+Image.h"

@implementation UITableViewRowAction (Image)

+ (nonnull instancetype)rowActionWithStyle:(UITableViewRowActionStyle)style image:(nullable UIImage *)image imageWidth:(CGFloat)width handler:(nullable void (^)(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath))handler {
    NSString *stringForWidth = [NSString getStringWithWidth:width inFont:[UIFont systemFontOfSize:15]];
    NSLog(@"%f", [stringForWidth widthForFont:[UIFont systemFontOfSize:15]]);
    UITableViewRowAction *rowAction = [self rowActionWithStyle:style title:stringForWidth handler:handler];
    rowAction.image = image;
    rowAction.imageWidth = width;
    return rowAction;
}

- (void)setImageWidth:(CGFloat)imageWidth{
    objc_setAssociatedObject(self, @selector(imageWidth), @(imageWidth), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)imageWidth{
    NSNumber *width = objc_getAssociatedObject(self, _cmd);
    return (width ? width.floatValue : 0);
}

- (void)setImage:(UIImage *)image {
    objc_setAssociatedObject(self, @selector(image), image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)image {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setIndex:(NSNumber *)index{
    objc_setAssociatedObject(self, @selector(index), index, OBJC_ASSOCIATION_ASSIGN);
}

- (NSNumber *)index{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEnabled:(BOOL)enabled {
    objc_setAssociatedObject(self, @selector(enabled), @(enabled), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)enabled {
    id enabled = objc_getAssociatedObject(self, _cmd);
    return enabled ? [enabled boolValue] : true;
}

@end
