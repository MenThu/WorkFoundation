//
//  UIViewController+Hint.m
//  BM4Group
//
//  Created by 陈宇 on 16/2/1.
//  Copyright © 2016年 陈宇. All rights reserved.
//

#import "UIViewController+Message.h"

@implementation UIViewController (Message)

#if __has_include(<YYKit/YYKit.h>)
static YYLabel *_label;
#else
static UILabel *_label;
#endif

- (void)showMessage:(NSString *)message
{
    [self showMessage:message type:HintTypeSuccessful];
}

- (void)showMessage:(NSString *)message offset:(CGFloat)offset
{
    [self showMessage:message type:HintTypeSuccessful offset:offset];
}

- (void)showMessage:(NSString *)message type:(HintType)type
{
    [self showMessage:message type:type offset:0];
}

- (void)showMessage:(NSString *)message type:(HintType)type offset:(CGFloat)offset
{
    if (![message isNotBlank]) return;

    static CGFloat padding = 10.f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if __has_include(<YYKit / YYKit.h>)
        _label = [[YYLabel alloc] init];
        _label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _label.textContainerInset = UIEdgeInsetsMake(padding, padding * 2, padding, padding * 2);
#else
        _label = [[UILabel alloc] init];
#endif
        _label.numberOfLines = 0;
        _label.userInteractionEnabled = NO;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14.f];
        _label.textColor = [UIColor whiteColor];
    });

    // 设置背景色
    switch (type) {
        case HintTypeSuccessful:
            _label.backgroundColor = [UIColor colorWithRed:0.033 green:0.685 blue:0.978 alpha:0.830];
            break;
        case HintTypeFailure:
            _label.backgroundColor = [UIColor colorWithRed:0.963 green:0.085 blue:0.078 alpha:0.830];
            break;
    }

    _label.width = self.view.width;
    _label.height = [message sizeForFont:_label.font size:CGSizeMake(_label.width - 4 * padding, HUGE) mode:NSLineBreakByWordWrapping].height + 2 * padding + 20;
    _label.text = message;

    if (_label.superview) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideMessage) object:nil];
        _label.top = [self defaultOffset] + offset;
    }
    else {
        _label.bottom = [self defaultOffset] + offset;
        if (self.navigationController && ![self.navigationController isNavigationBarHidden]) {
            [self.navigationController.view insertSubview:_label belowSubview:self.navigationController.navigationBar];
        }
        else {
            [self.view insertSubview:_label atIndex:self.view.subviews.count];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _label.transform = CGAffineTransformMakeTranslation(0, _label.height);
        }];
    }
    [self performSelector:@selector(hideMessage) withObject:nil afterDelay:2];
}

- (void)hideMessage
{
    [UIView animateWithDuration:0.2 animations:^{
        _label.transform = CGAffineTransformIdentity;
    }
        completion:^(BOOL finished) {
            [_label removeFromSuperview];
        }];
}

- (CGFloat)defaultOffset
{
    CGFloat offset = 0.f;

    if (![UIApplication sharedApplication].statusBarHidden) offset += 20.f;

    if (self.navigationController && !self.navigationController.navigationBarHidden) offset += 44.f;

    return offset;
}

- (BOOL)isNavigationBarShow
{
    return self.navigationController && ![self.navigationController.navigationBar isHidden];
}

/*
 - (void)showWithView:(UIView *)view
 {
 CABasicAnimation *showAnim = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
 showAnim.fromValue = @(- view.height);
 showAnim.toValue = @(view.height);
 showAnim.duration = 0.2;
 showAnim.fillMode = kCAFillModeForwards;
 showAnim.removedOnCompletion = NO;
 [view.layer addAnimation:showAnim forKey:@"showAnim"];
 }
 
 - (void)hideWithView:(UIView *)view delay:(CFTimeInterval)time
 {
 CABasicAnimation *hideAnim = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
 hideAnim.delegate = self;
 NSLog(@"%@", view.layer.presentationLayer);
 hideAnim.toValue = @(([self isNavigationBarShow] ? 64 : 0) - view.height);
 hideAnim.duration = 0.2;
 hideAnim.beginTime = CACurrentMediaTime() + time;
 [view.layer addAnimation:hideAnim forKey:@"hideAnim"];
 }
 
 - (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
 {
 if (flag) {
 [_label removeFromSuperview];
 [_label.layer removeAllAnimations];
 }
 }
 */
@end
