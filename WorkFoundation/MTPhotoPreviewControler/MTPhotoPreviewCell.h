//
//  MTPhotoPreviewCell.h
//  artapp
//
//  Created by MenThu on 17/7/11.
//  Copyright © 2017年 SJWL. All rights reserved.
//

#import "MTBaseCollectionCell.h"

@interface MTPhotoPreviewCell : MTBaseCollectionCell

@property (nonatomic, copy) void (^singleTapCell) ();

@end
