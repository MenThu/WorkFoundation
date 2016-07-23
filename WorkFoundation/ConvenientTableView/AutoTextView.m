//
//  AutoTextView.m
//  TestKeyBoard
//
//  Created by MenThu on 16/7/12.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "AutoTextView.h"


@interface AutoTextView ()<UITextViewDelegate>

@property (assign,nonatomic)CGRect frameInScrollView;
@property (assign,nonatomic)CGFloat naviHeight;
@property (weak, nonatomic)UIScrollView *moveScrollView;
@property (assign, nonatomic)CGFloat keyBoardHeight;

@property (assign ,nonatomic)CGFloat screenWidth;
@property (assign ,nonatomic)CGFloat screenHeight;

@property (assign, nonatomic)CGFloat cursorToKeyBottomSpace;

@property (assign, nonatomic)CGFloat cursorTopSpace;

@end

@implementation AutoTextView

- (void)setupWithNaviHeight:(CGFloat)height superView:(UIView *)superView ScrollView:(UIScrollView *)scrollView
{
    self.moveScrollView = scrollView;
    self.naviHeight = height;
    self.frameInScrollView = [scrollView convertRect:self.frame fromView:superView];
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.cursorToKeyBottomSpace = 50;
    self.cursorTopSpace = 50;
    self.scrollEnabled = NO;
    self.delegate = self;
    [self registerKeyBoard];

}



- (void)registerKeyBoard
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    if ([value CGRectValue].size.height <= 0) {
        return;
    }
    
    self.keyBoardHeight = [value CGRectValue].size.height;
    
    if (self.isFirstResponder) {
        [self performSelector:@selector(textViewDidChangeSelection:) withObject:self afterDelay:0.1f];
    }
}


#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self performSelector:@selector(textViewDidChangeSelection:) withObject:self afterDelay:0.1f];
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    //找寻UITextView的光标位置
    CGFloat cursorPosition;
    if (self.selectedTextRange) {
        cursorPosition = [self caretRectForPosition:self.selectedTextRange.start].origin.y;
    } else {
        cursorPosition = 0;
    }
    //为了精确的滚动到鼠标的位置，尤其在复制粘贴的时候，这句代码有作用
    CGRect cursorRowFrame = CGRectMake(0, cursorPosition, self.screenWidth, self.font.lineHeight*2);
    [self scrollRectToVisible:cursorRowFrame animated:NO];
    
    
    
    
    CGFloat cursorToScrollTopSpace = self.frameInScrollView.origin.y + cursorPosition  - self.moveScrollView.contentOffset.y;
    CGFloat editFieldTopSpace = cursorToScrollTopSpace + self.cursorToKeyBottomSpace;
    CGFloat keyBoardTopSpace = self.screenHeight -  - self.naviHeight - self.keyBoardHeight;
    CGFloat offsetY = editFieldTopSpace - keyBoardTopSpace ;
    
    if (cursorToScrollTopSpace < 0) {
        //光标在屏幕顶端以上
        NSLog(@"tag : [%ld] Down", (long)textView.tag);
        [self.moveScrollView setContentOffset:CGPointMake(0, self.moveScrollView.contentOffset.y+cursorToScrollTopSpace-self.cursorTopSpace) animated:YES];
    }else if(offsetY>0){
        
        NSLog(@"tag : [%ld] Up", (long)textView.tag);
        //比较当前输入的实体的光标和键盘的位置
        [self.moveScrollView setContentOffset:CGPointMake(0, self.moveScrollView.contentOffset.y + offsetY) animated:YES];
    }
    if (self.frame.size.height < self.contentSize.height) {
        //需要回调block更改自身的高度
        if (self.changeBlock) {
            self.changeBlock(self.contentSize.height);
        }
    }
}

@end
