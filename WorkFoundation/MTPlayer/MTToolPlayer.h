//
//  MTToolPlayer.h
//  MTTest
//
//  Created by MenThu on 2017/3/31.
//  Copyright © 2017年 官辉. All rights reserved.
//

#import "MTBaseAVPlayer.h"

@interface MTToolPlayer : MTBaseAVPlayer

@property (nonatomic, weak) UIView *normalSuperView;

@property (nonatomic, copy) void (^tapGesture) (BOOL isHidden);

@property (nonatomic, copy) void (^isPlayerFullScreen) (BOOL isFull);

@property (nonatomic, copy) void (^quitPlayer) (void);

@property (nonatomic, strong) NSDictionary *shareInfo;

@end
