//
//  AnimateManager.h
//  TestCocoapod
//
//  Created by MenThu on 16/9/1.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef void(^AnimateDone)(id);

@interface AnimateManager : NSObject

kSingletonH;

- (void)upAndDownAnimate:(UIView *)UpView Down:(UIView *)downView MoveSpace:(CGFloat)moveSpace AllDown:(AnimateDone)doneBlock;

@end
