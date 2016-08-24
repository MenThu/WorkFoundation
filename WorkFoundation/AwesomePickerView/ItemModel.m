//
//  ItemModel.m
//  TestPicker
//
//  Created by MenThu on 16/8/19.
//  Copyright © 2016年 官辉. All rights reserved.
//

//@interface SubItemModel : NSObject
//
//@property (nonatomic, copy) NSString *areaName;
//
//@property (nonatomic, strong) NSNumber *areaId;
//
//@end
//
//@implementation SubItemModel
//
//
//
//@end

#import "ItemModel.h"

@implementation ItemModel


- (instancetype)init
{
    if (self = [super init]) {
        self.itemName = @"";
        self.nextArray = nil;
    }
    return self;
}


- (NSString *)description
{
    /**
     @property (nonatomic, strong) NSArray *area;
     
     @property (nonatomic, copy) NSString *eduName;
     
     @property (nonatomic, assign) NSInteger eduId;
     */
    return [NSString stringWithFormat:@"%@", @{@"itemName":self.itemName, @"nextArray":(self.nextArray == nil ? @"nil" : self.nextArray), @"area":self.area, @"eduName":self.eduName, @"eduId":@(self.eduId)}];
}

@end
