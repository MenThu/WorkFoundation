//
//  MTBaseView.h
//  artapp
//
//  Created by MenThu on 17/5/18.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTBaseView <T:NSObject *> : UIView

+ (instancetype)loadView;
- (CGFloat)getViewHeightWith:(id)Model;

@end
