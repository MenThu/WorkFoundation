//
//  AnimateManager.m
//  TestCocoapod
//
//  Created by MenThu on 16/9/1.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "AnimateManager.h"
#import "UIView+Convenience.h"

@interface AnimateManager ()

@property (nonatomic, copy) AnimateDone customBlock;

@end

@implementation AnimateManager

kSingletonM

- (void)upAndDownAnimate:(UIView *)UpView Down:(UIView *)downView MoveSpace:(CGFloat)moveSpace AllDown:(AnimateDone)doneBlock
{
    CGPoint upCenter = CGPointMake(UpView.centerX, UpView.centerY);
    CGPoint downCenter = CGPointMake(downView.centerX, downView.centerY);
    
    
    CGPoint afterMoveUpCenter = CGPointMake(upCenter.x, upCenter.y-moveSpace/2);
    CGPoint afterMoveDownCenter = CGPointMake(downCenter.x, downCenter.y+moveSpace/2);
    
    CABasicAnimation *translation1 = [CABasicAnimation animationWithKeyPath:@"position"];
    translation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation1.fromValue = [NSValue valueWithCGPoint:upCenter];
    translation1.toValue = [NSValue valueWithCGPoint:afterMoveUpCenter];
    translation1.duration = 0.4;
    translation1.repeatCount = 1;
    translation1.autoreverses = YES;
    
    //让imagdown上下移动
    CABasicAnimation *translation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    translation2.delegate = self;
    translation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation2.fromValue = [NSValue valueWithCGPoint:downCenter];
    translation2.toValue = [NSValue valueWithCGPoint:afterMoveDownCenter];
    translation2.duration = 0.4;
    translation2.repeatCount = 1;
    translation2.autoreverses = YES;
    
    self.customBlock = doneBlock;
    
    
    [UpView.layer addAnimation:translation1 forKey:@"translation1"];
    [downView.layer addAnimation:translation2 forKey:@"translation2"];
    
    [self performSelector:@selector(pauseAnimation:) withObject:@[UpView, downView] afterDelay:0.4];
    
}

- (void)pauseAnimation:(NSArray *)viewArray
{
    for (UIView *moveView in viewArray) {
        CFTimeInterval pauseTime = [moveView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        
        //2.设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        moveView.layer.timeOffset = pauseTime;
        
        //3.将动画的运行速度设置为0， 默认的运行速度是1.0
        moveView.layer.speed = 0;
    }
    
    
    [self performSelector:@selector(resumeAnimation:) withObject:viewArray afterDelay:0.4];
}

- (void)resumeAnimation:(NSArray *)viewArray
{
    for (UIView *moveView in viewArray) {
        //1.将动画的时间偏移量作为暂停的时间点
        CFTimeInterval pauseTime = moveView.layer.timeOffset;
        
        //2.计算出开始时间
        CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
        
        [moveView.layer setTimeOffset:0];
        [moveView.layer setBeginTime:begin];
        
        moveView.layer.speed = 1;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag && self.customBlock) {
        self.customBlock(nil);
    }
}


@end
