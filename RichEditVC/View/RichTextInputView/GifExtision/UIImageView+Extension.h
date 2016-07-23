//
//  UIImageView+Extension.h
//  Legendary
//
//  Created by jz100ios on 16/6/8.
//
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)
//解析gif文件数据的方法 block中会将解析的数据传递出来
-(void)getGifImageWithUrk:(NSURL *)url
               returnData:(void(^)(NSArray<UIImage *> * imageArray,
                                   NSArray<NSNumber *>*timeArray,
                                   CGFloat totalTime,
                                   NSArray<NSNumber *>* widths,
                                   NSArray<NSNumber *>* heights))dataBlock;


-(void)yh_setImage:(NSURL *)imageUrl;



@end
