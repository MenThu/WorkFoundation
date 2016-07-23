//
//  AutoTextView.h
//  TestKeyBoard
//
//  Created by MenThu on 16/7/12.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ChangeSelfHeight)(CGFloat height);

@interface AutoTextView : UITextView

- (void)setupWithNaviHeight:(CGFloat)height superView:(UIView *)superView ScrollView:(UIScrollView *)scrollView;

@property (copy, nonatomic)ChangeSelfHeight changeBlock;

@end
