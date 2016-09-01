//
//  ShakeManager.m
//  TestCocoapod
//
//  Created by MenThu on 16/9/1.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "ShakeManager.h"
#import <AudioToolbox/AudioToolbox.h>

static ShakeManager *selfPoint;

@interface ShakeManager ()

{
    SystemSoundID _customSound;
}

@end

@implementation ShakeManager

kSingletonM

- (instancetype)init
{
    if (self = [super init]) {
        selfPoint = self;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"wxls.mp3" ofType:nil];
        NSURL *localSoundUrl = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)localSoundUrl, &_customSound);
    }
    return self;
}

- (void)setShakeType:(ShakeType)shakeType
{
    _shakeType = shakeType;
}


- (void)playShake
{
    switch (self.shakeType) {
        case ShakeOnly:
        {
            AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, soundCompleteCallback, NULL);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
            break;
        case SoundOnly:
        {
            AudioServicesPlaySystemSound(_customSound);
        }
            break;
            
        default:
            break;
    }
}

- (void)stopShake
{
    
}

- (void)triggerShake
{
    //只有震动的类型才会走到这里
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
}

void soundCompleteCallback(SystemSoundID sound,void * clientData)
{
    [selfPoint performSelector:@selector(triggerShake) withObject:nil afterDelay:0.2];
}

@end
