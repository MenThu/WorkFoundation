//
//  BigView.h
//  CGLearn
//
//  Created by MenThu on 16/7/1.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigView : UIImageView

+ (instancetype)shareInstance;
-(void)showGifWithGifName:(NSString *)gitSting button:(UICollectionViewCell *)cell;
@end
