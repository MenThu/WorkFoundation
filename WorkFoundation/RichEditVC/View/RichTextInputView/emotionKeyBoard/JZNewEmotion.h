//
//  JZNewEmotion.h
//  Legendary
//
//  Created by jz100ios on 16/6/7.
//
//

#import <Foundation/Foundation.h>

@interface JZNewEmotion : NSObject <NSCoding>
/**
 *  表情编码
 */
@property(nonatomic,copy)NSString *code;
/**
 *  表情地址
 */
@property(nonatomic,copy)NSString *url;

/**
 *  文件地址
 */
@property(nonatomic,copy)NSString *file;
@end
