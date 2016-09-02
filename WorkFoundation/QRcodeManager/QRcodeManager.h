//
//  QRcodeManager.h
//  QRcode_GHdemo
//
//  Created by MenThu on 16/9/2.
//  Copyright © 2016年 Hope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRcodeManager : NSObject


+ (UIImage *)createORImageWithInfo:(NSString *)ORString andSize:(CGSize)ORImageSize centerIcon:(UIImage *)centerImage;

@end
