//
//  JZEmotionTool.h
//  Legendary
//
//  Created by jz100ios on 16/6/4.
//
//

#import <Foundation/Foundation.h>
@class JZNewEmotion;


@interface JZEmotionTool : NSObject<NSXMLParserDelegate>


+ (instancetype)shareInstance;

/**
 *  默认表情
 */
-(NSArray *)getNormalEmotions;

/**
 *  获取洋葱表情
 */
-(NSArray *)getOnionEmotions;

/**
 *  获取星星表情
 */
-(NSArray *)getStarEmotions;

/**
 *  最近使用表情数组
 */
-(NSArray *)getPresentEmotion;

/**
 *  存储到最近使用表情数组中
 */
-(void)savePresentEmotionWithEmotion:(JZNewEmotion *)emotion;

@end
