//
//  MTBaseCell.h
//  TestStoryboard
//
//  Created by MenThu on 2016/11/21.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTBaseModel.h"
#import "UITableViewRowAction+Image.h"

@interface MTBaseCell : UITableViewCell

@property (nonatomic, weak) id cellModel;

//子类应该覆盖的方法
- (void)configCustomView;
//Model被更新后，会调用的方法
- (void)updateCustomView;

@end
