//
//  MTBaseModel.h
//  TestStoryboard
//
//  Created by MenThu on 2016/11/21.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@interface MTBaseCellModel : NSObject

//Cell的行高
@property (nonatomic, assign) CGFloat cellHeight;

//cell的单元格
@property (nonatomic, weak) NSIndexPath *cellIndexPath;

@end
