//
//  UIButton+Exten.m
//  UIButton+Exten
//
//  Created by MenThu on 2018/1/24.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "UIButton+Exten.h"
#import <objc/runtime.h>

@interface _ButtonModeSeting : NSObject

@property (nonatomic, assign) CGFloat imgTextSpace;

@end

@implementation _ButtonModeSeting
@end

@implementation UIButton (Exten)

//+ (void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//
//        SEL originalSelector = @selector(layoutSubviews);
//        SEL swizzledSelector = @selector(mt_layoutSubviews);
//
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//
//        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//        if (success) {
//            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    });
//}
//
//- (CGFloat)imgTextSpace{
//    NSNumber *imgTextSpace = objc_getAssociatedObject(self, _cmd);
//    if (imgTextSpace == nil) {
//        imgTextSpace = @(0);
//        objc_setAssociatedObject(self, _cmd, imgTextSpace, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    return imgTextSpace.floatValue;
//}
//
//- (ButtonDisplayMode)imgMode{
//    NSNumber *imgMode = objc_getAssociatedObject(self, _cmd);
//    if (imgMode == nil) {
//        imgMode = @(ButtonDisplayModeImgLeftTextRight);
//        objc_setAssociatedObject(self, _cmd, imgMode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    return imgMode.integerValue;
//}
//
//- (void)setImgTextSpace:(CGFloat)imgTextSpace{
//    objc_setAssociatedObject(self, @selector(imgTextSpace), @(imgTextSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self commonConfigBtn];
//}
//
//- (void)setImgMode:(ButtonDisplayMode)imgMode{
//    objc_setAssociatedObject(self, @selector(imgMode), @(imgMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self commonConfigBtn];
//}
//
//- (void)mt_layoutSubviews{
//    NSLog(@"mt_layoutSubviews");
//    [self mt_layoutSubviews];
//    if (self.imgMode == ButtonDisplayModeImgLeftTextRight && self.imgTextSpace == 0) {//未对button做样式要求
//        return;
//    }
//    switch (self.imgMode) {
//        case ButtonDisplayModeImgLeftTextRight:
//        {
//            [self imgLeftTextRight];
//        }
//            break;
//        case ButtonDisplayModeImgRightTextLeft:
//        {
//            [self imgRightTextLeft];
//        }
//            break;
//        case ButtonDisplayModeImgUpTextBottom:
//        {
//            [self imgUpTextBottom];
//        }
//            break;
//        case ButtonDisplayModeImgBottomTextUp:
//        {
//            [self imgBottomTextUp];
//        }
//            break;
//
//        default:
//            break;
//    }
//}

- (void)adjustImgTextPosition:(ButtonDisplayMode)mode space:(CGFloat)imgTextSpace{
    [self commonConfigBtn];
    switch (mode) {
        case ButtonDisplayModeImgLeftTextRight:
        {
            [self imgLeftTextRight:imgTextSpace];
        }
            break;
        case ButtonDisplayModeImgRightTextLeft:
        {
            [self imgRightTextLeft:imgTextSpace];
        }
            break;
        case ButtonDisplayModeImgUpTextBottom:
        {
            [self imgUpTextBottom:imgTextSpace];
        }
            break;
        case ButtonDisplayModeImgBottomTextUp:
        {
            [self imgBottomTextUp:imgTextSpace];
        }
            break;
            
        default:
            break;
    }
}

- (void)commonConfigBtn{
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
}

- (void)imgLeftTextRight:(CGFloat)space{
    //图片在左边，文字在右边（图片和文字整体居中）
    CGFloat imageWidth = self.imageView.bounds.size.width;
    CGFloat labelWidth = self.titleLabel.bounds.size.width;

    CGFloat imageHeight = self.imageView.bounds.size.height;
    CGFloat labelHeight = self.titleLabel.bounds.size.height;

    CGFloat btnWidth = self.bounds.size.width;
    CGFloat btnHeight = self.bounds.size.height;

    CGFloat imageVerMoveSpace = btnHeight/2 - imageHeight/2;
    CGFloat labelVerMoveSpace = btnHeight/2 - labelHeight/2;

    CGFloat imageHorizonMoveSpace = btnWidth/2 - (imageWidth+space+labelWidth)/2;
    CGFloat labelHorizonMoveSpace = space + imageHorizonMoveSpace;

    self.imageEdgeInsets = UIEdgeInsetsMake(imageVerMoveSpace, imageHorizonMoveSpace, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(labelVerMoveSpace, labelHorizonMoveSpace, 0, 0);
}

- (void)imgRightTextLeft:(CGFloat)space{
    CGFloat imageWidth = self.imageView.bounds.size.width;
    CGFloat labelWidth = self.titleLabel.bounds.size.width;
    
    CGFloat imageHeight = self.imageView.bounds.size.height;
    CGFloat labelHeight = self.titleLabel.bounds.size.height;
    
    CGFloat btnWidth = self.bounds.size.width;
    CGFloat btnHeight = self.bounds.size.height;
    
    CGFloat temp = (btnWidth - (labelWidth+imageWidth+space))/2;
    CGFloat labelHorizonMoveSpace = -imageWidth + temp;
    CGFloat imageHorizonMoveSpace = labelWidth + space +  temp;
    
    
    CGFloat labelVerMoveSpace = btnHeight/2 - labelHeight/2;
    CGFloat imageVerMoveSpace = btnHeight/2 - imageHeight/2;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageVerMoveSpace, imageHorizonMoveSpace, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(labelVerMoveSpace, labelHorizonMoveSpace, 0, 0);
}

- (void)imgUpTextBottom:(CGFloat)space{
    CGFloat imageWidth = self.imageView.bounds.size.width;
    CGFloat labelWidth = self.titleLabel.bounds.size.width;
    
    CGFloat imageHeight = self.imageView.bounds.size.height;
    CGFloat labelHeight = self.titleLabel.bounds.size.height;
    
    CGFloat btnWidth = self.bounds.size.width;
    CGFloat btnHeight = self.bounds.size.height;
    
    CGFloat labelHorizonMoveSpace = -imageWidth + (btnWidth - labelWidth)/2;
    CGFloat imageHorizonMoveSpace = (btnWidth - imageWidth)/2;
    
    CGFloat temp = (btnHeight - (imageHeight + space + labelHeight))/2;
    
    CGFloat labelVerMoveSpace = imageHeight + space + temp;
    CGFloat imageVerMoveSpace = temp;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageVerMoveSpace, imageHorizonMoveSpace, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(labelVerMoveSpace, labelHorizonMoveSpace, 0, 0);
}

- (void)imgBottomTextUp:(CGFloat)space{
    CGFloat imageWidth = self.imageView.bounds.size.width;
    CGFloat labelWidth = self.titleLabel.bounds.size.width;
    
    CGFloat imageHeight = self.imageView.bounds.size.height;
    CGFloat labelHeight = self.titleLabel.bounds.size.height;
    
    CGFloat btnWidth = self.bounds.size.width;
    CGFloat btnHeight = self.bounds.size.height;
    
    CGFloat labelHorizonMoveSpace = -imageWidth + (btnWidth - labelWidth)/2;
    CGFloat imageHorizonMoveSpace = (btnWidth - imageWidth)/2;
    
    CGFloat temp = (btnHeight - (imageHeight + space + labelHeight))/2;
    
    CGFloat labelVerMoveSpace = temp;
    CGFloat imageVerMoveSpace = labelHeight + space + temp;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageVerMoveSpace, imageHorizonMoveSpace, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(labelVerMoveSpace, labelHorizonMoveSpace, 0, 0);
}

@end
