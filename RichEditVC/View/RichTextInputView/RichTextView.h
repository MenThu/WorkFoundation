//
//  RichTextView.h
//  CGLearn
//
//  Created by MenThu on 16/6/29.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHead.h"

@interface RichTextView : UITextView

@property (copy, nonatomic)ChangeFirstResponder changeBlock;
//TextViewDidChange
@property (copy, nonatomic)TextViewDidChange valueDidChange;

@property (assign, nonatomic)NSInteger viewTag;

@end
