//
//  MTCollectionViewRegisterModel.h
//  MTCollectionView
//
//  Created by MenThu on 2017/12/4.
//  Copyright © 2017年 MenThu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTRegisterModel : NSObject

/**
 *  register的cell名字
 **/
@property (nonatomic, copy) NSString *cellClassName;

/**
 *  是否来自xib
 **/
@property (nonatomic, assign) BOOL isCellFromXib;

@end
