//
//  MTPickerModel.h
//  MTTest
//
//  Created by MenThu on 2017/4/28.
//  Copyright © 2017年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemModel.h"

@interface MTPickerModel : NSObject

/**
 *  pickerView的title
 **/
@property (nonatomic, copy) NSString *pickerTitle;

/**
 *  pickerView的数据源
 **/
@property (nonatomic, strong) NSArray <ItemModel *> *pickerSource;

@end
