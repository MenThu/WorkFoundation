//
//  AVAsset+Work.m
//  MTTest
//
//  Created by MenThu on 2017/4/19.
//  Copyright © 2017年 官辉. All rights reserved.
//

#import "AVAsset+Work.h"

@implementation AVAsset (Work)

+ (void)getAVAssetSize:(NSString *)videoUrl size:(void(^)(CGSize videoSize))videoSizeBlock {
    AVAsset *videoAsset = [AVAsset assetWithURL:[NSURL URLWithString:videoUrl]];
    __block CGSize videoSize = CGSizeZero;
    [videoAsset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (videoAsset.playable) {
                NSArray *array = videoAsset.tracks;
                for (AVAssetTrack *track in array) {
                    if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
                        videoSize = track.naturalSize;
                    }
                }
            }
        });
    }];
    //回调视频大小
    if (videoSizeBlock) {
        videoSizeBlock(videoSize);
    }
}

@end
