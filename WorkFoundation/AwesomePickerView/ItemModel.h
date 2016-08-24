//
//  ItemModel.h
//  TestPicker
//
//  Created by MenThu on 16/8/19.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ItemModel : NSObject

@property (nonatomic, copy) NSString* itemName;

@property (nonatomic, strong) NSArray <ItemModel *> *nextArray;




@property (nonatomic, strong) NSArray  *area;

@property (nonatomic, copy) NSString *eduName;

@property (nonatomic, assign) NSInteger eduId;

@end
