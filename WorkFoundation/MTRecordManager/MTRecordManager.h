//
//  MTRecordManager.h
//  MTRecord
//
//  Created by MenThu on 2017/2/4.
//  Copyright © 2017年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTRecordManager : NSObject

kSingletonH

/**
    *   文件的地址前缀,必须以"/"结尾
 **/
@property (nonatomic, copy) NSString *filePath;

/**
    每次调用会生成一个新的录音文件，默认以系统时间命名
 **/
- (void)startRecord:(void (^)(NSString *fileName, CGFloat audioDuration))finishRecord;

/**
    暂停录音
 **/
- (void)pasuRecord;

/**
    会使用上一次的文件继续录音
 **/
- (void)resumeRecord;

/**
    结束录音[保存录音文件]
 **/
- (void)endRecord;

/**
    取消录音，不会保存录音文件
 **/
- (void)cancelRecord;

/**
    播放方法
    filePathAndNameOrData 可以是文件全路径也可以是字节流
    finisPlay 播放完成的回调block 不允许为空
 **/
- (void)playSound:(id)filePathAndNameOrData finishPlay:(void (^)())finisPlay;

/**
    暂停播放器
 **/
- (void)pausePlay;

/**
    停止播放器
 **/
- (void)endPlay;


/**
    将pcm转码成mp3
 
    @params pcmFilePath 输入待转码的全路径
    
    @params finishBlock 返回文件路径和字节流
 **/
- (void)enCodePCM2Mp3:(NSString *)pcmFilePath outFile:(void (^)(NSString *mp3FilePath, NSData *outData))finishBlock;

@end
