//
//  WorkFoundation.h
//  TestGitHub
//
//  Created by MenThu on 16/7/21.
//  Copyright © 2016年 官辉. All rights reserved.
//

#ifndef WorkFoundation_h
#define WorkFoundation_h


#import <AFNetworking.h>
#import <Masonry.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import <YYKit.h>


#if __has_include(<WorkFoundation/WorkFoundation.h>)


#import <WorkFoundation/ZLPhoto.h>
#import <WorkFoundation/CameraManager.h>
#import <WorkFoundation/MyLog.h>
#import <WorkFoundation/MyCategory.h>
#import <WorkFoundation/HttpLibrary.h>
#import <WorkFoundation/ConvenientView.h>

#import <WorkFoundation/MyTimer.h>
#import <WorkFoundation/XHSoundRecorder.h>
#import <WorkFoundation/THObserver.h>
#import <WorkFoundation/Singleton.h>
#import <WorkFoundation/amrFileCodec.h>
#import <WorkFoundation/FileManager.h>
#import <WorkFoundation/AwesomePickerView.h>
#import <WorkFoundation/ScanManager.h>
#import <WorkFoundation/ShakeManager.h>
#import <WorkFoundation/AnimateManager.h>


#else

#import "ZLPhoto.h"
#import "CameraManager.h"
#import "MyLog.h"
#import "MyCategory.h"
#import "HttpLibrary.h"
#import "ConvenientView.h"

#import "MyTimer.h"
#import "XHSoundRecorder.h"
#import "THObserver.h"
#import "Singleton.h"
#import "amrFileCodec.h"
#import "FileManager.h"
#import "AwesomePickerView.h"
#import "ScanManager.h"
#import "ShakeManager.h"
#import "AnimateManager.h"


#endif


#endif /* WorkFoundation_h */
