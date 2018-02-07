//
//  MTProxy.h
//  MTCollectionView
//
//  Created by MenThu on 2017/12/4.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTProxy : NSObject

/**
 *  消息的第一接受者
 **/
@property (nonatomic, strong) id topRecevier;

/**
 *  消息的第二接受者
 **/
@property (nonatomic, strong) id secondRecevier;

@end
