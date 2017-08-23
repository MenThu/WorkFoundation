//
//  AVAsset+Work.h
//  MTTest
//
//  Created by MenThu on 2017/4/19.
//  Copyright © 2017年 官辉. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAsset (Work)

+ (void)getAVAssetSize:(NSString *)videoUrl size:(void(^)(CGSize videoSize))videoSizeBlock;

@end
