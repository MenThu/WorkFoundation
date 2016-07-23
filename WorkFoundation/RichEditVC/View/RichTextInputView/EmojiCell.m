//
//  EmojiCell.m
//  CGLearn
//
//  Created by MenThu on 16/6/30.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "EmojiCell.h"
#import "JZNewEmotion.h"

@interface EmojiCell ()

@property (weak, nonatomic) IBOutlet UIImageView *emojiFace;


@end

@implementation EmojiCell

- (void)awakeFromNib {

}

- (void)setModel:(JZNewEmotion *)model
{
    _model = model;
    if (self.model) {
        self.emojiFace.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",self.model.file,self.model.url]];
    }
}

@end
