//
//  MTTextField.m
//  JiangL
//
//  Created by MenThu on 2017/12/11.
//  Copyright © 2017年 Aladdin. All rights reserved.
//

#import "MTTextField.h"

@implementation MTTextField

#pragma mark - LifeCircle
- (void)awakeFromNib{
    [super awakeFromNib];
    [self configView];
}

- (instancetype)init{
    if (self = [super init]) {
        [self configView];
    }
    return self;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position{
    CGRect originalRect = [super caretRectForPosition:position];
    CGFloat centerX = CGRectGetMidX(originalRect);
    CGFloat centerY = CGRectGetMidY(originalRect);
    CGFloat newWidth = self.cursorSize.width;
    CGFloat newHeight = self.cursorSize.height;
    //光标应该和文字竖直居中
    CGFloat newOriginX = centerX - newWidth/2;
    CGFloat newOriginY = centerY - newHeight/2;
    CGRect newRect = CGRectMake(newOriginX, newOriginY, newWidth, newHeight);
    return newRect;
}

#pragma mark - Private
- (void)configView{
    _cursorSize = CGSizeMake(5, self.font.lineHeight+2);
}

#pragma mark - Setter
- (void)setCursorSize:(CGSize)cursorSize{
    _cursorSize = cursorSize;
    MyLog(@"cursorSize=[%@]", NSStringFromCGSize(cursorSize));
}

@end
