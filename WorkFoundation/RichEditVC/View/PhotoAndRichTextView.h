//
//  PhotoAndRichTextView.h
//  CGLearn
//
//  Created by MenThu on 16/7/15.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichTextView.h"

typedef void(^DeleteImage)(id thisView);

@interface PhotoAndRichTextView : UIView

+ (instancetype)loadThisView;


@property (strong, nonatomic)UIImage* selectImage;
@property (copy, nonatomic)DeleteImage deleteBlock;

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@property (weak, nonatomic) IBOutlet RichTextView *richInputTextView;

@property (assign, nonatomic)NSInteger viewTag;

@end
