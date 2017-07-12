//
//  MTPhotoPreviewModel.m
//  artapp
//
//  Created by MenThu on 17/7/11.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "MTPhotoPreviewModel.h"

@implementation MTPhotoPreviewModel

- (instancetype)init{
    if (self = [super init]) {
        self.type = -1;
        self.imgUrl = @"";
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@", @{@"type":@(self.type), @"imgUrl":self.imgUrl}];
}

@end
