//
//  MTProxy.m
//  MTCollectionView
//
//  Created by MenThu on 2017/12/4.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import "MTProxy.h"

@interface MTProxy ()

@end

@implementation MTProxy

#pragma mark - 消息转发
- (BOOL)respondsToSelector:(SEL)aSelector{
    NSLog(@"respond=[%s]", sel_getName(aSelector));
    if ([self.topRecevier respondsToSelector:aSelector]) {
        return YES;
    }else if ([self.secondRecevier respondsToSelector:aSelector]){
        return YES;
    }else{
        return [super respondsToSelector:aSelector];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"forwarding=[%s]", sel_getName(aSelector));
    if ([self.topRecevier respondsToSelector:aSelector]) {
        return self.topRecevier;
    }else if ([self.secondRecevier respondsToSelector:aSelector]){
        return self.secondRecevier;
    }else{
        return [super forwardingTargetForSelector:aSelector];
    }
}

@end
