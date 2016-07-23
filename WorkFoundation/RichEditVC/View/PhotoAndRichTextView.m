



//
//  PhotoAndRichTextView.m
//  CGLearn
//
//  Created by MenThu on 16/7/15.
//  Copyright © 2016年 官辉. All rights reserved.
//
#import "PhotoAndRichTextView.h"

@interface PhotoAndRichTextView ()

//Image的宽高之比
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;

@property (assign, nonatomic)CGFloat viewWidth;

@end

#import "PhotoAndRichTextView.h"

@implementation PhotoAndRichTextView

+ (id)loadThisView{ 
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject; \
}

- (void)awakeFromNib
{
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
}



- (void)setSelectImage:(UIImage *)selectImage
{
    _selectImage = selectImage;
    self.photoImage.image = selectImage;
    self.imageViewHeight.constant = self.viewWidth / (selectImage.size.width / selectImage.size.height);
}

- (IBAction)deleteMySelf:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self);
        [self removeFromSuperview];
    }
}

- (void)setViewTag:(NSInteger)viewTag
{
    _viewTag = viewTag;
    self.richInputTextView.viewTag = viewTag;
}

@end
