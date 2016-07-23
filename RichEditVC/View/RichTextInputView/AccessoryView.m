//
//  accessoryView.m
//  CGLearn
//
//  Created by MenThu on 16/6/30.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "AccessoryView.h"

@implementation AccessoryView

+ (instancetype)loadView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}



- (IBAction)addBtnclick:(id)sender {
    if (self.block) {
        UIButton *btn = (UIButton *)sender;
        if (btn.tag == 1) {
            //添加表情按钮点击
            if (btn.selected == NO) {
                //用户要添加表情
                self.block(addImage);
            }else{
                //用户要添加文字
                self.block(addText);
            }
        }else{
            self.block(addPhoto);
        }
        btn.selected = !btn.selected;
    }
    
}


@end
