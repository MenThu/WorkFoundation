//
//  InputView.m
//  CGLearn
//
//  Created by MenThu on 16/6/30.
//  Copyright © 2016年 官辉. All rights reserved.
//


#import "InputView.h"
#import "ToolView.h"
#import "KeyBoadrView.h"
#import "JZEmotionTool.h"
#import "CommonHead.h"


@interface InputView ()

@property (weak, nonatomic) IBOutlet KeyBoadrView *keyBoardView;

@property (weak, nonatomic) IBOutlet ToolView *toolView;

@end


@implementation InputView

+ (instancetype)loadView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}

- (void)awakeFromNib
{
    [self configUI];
}

- (void)configUI
{
    self.keyBoardView.emojiArray = [self getEmojiDataWith:typeNormal];
    
    
    WeakSelf;
    self.toolView.emojiChangeBlock = ^(EmojiType type){
        weakSelf.keyBoardView.emojiArray = [weakSelf getEmojiDataWith:type];
    };
}


- (NSArray *)getEmojiDataWith:(EmojiType)type
{
    switch (type) {
        case typeRecently:
        {
            return [[JZEmotionTool shareInstance] getPresentEmotion];
        }
            break;
        case typeNormal:
        {
            return [[JZEmotionTool shareInstance] getNormalEmotions];
        }
            break;
        case typeOther:
        {
            return [[JZEmotionTool shareInstance] getOnionEmotions];
        }
            break;
            
        default:
            break;
    }
    return nil;
}

@end
