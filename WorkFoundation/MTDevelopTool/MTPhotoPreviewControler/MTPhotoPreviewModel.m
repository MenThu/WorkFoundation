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

- (void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    _type = 0;
}

- (void)setImgIcon:(UIImage *)imgIcon{
    _imgIcon = imgIcon;
    _type = 1;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@", @{@"type":@(self.type), @"imgUrl":self.imgUrl}];
}

@end
