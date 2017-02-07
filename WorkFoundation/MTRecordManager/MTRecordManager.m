//
//  MTRecordManager.m
//  MTRecord
//
//  Created by MenThu on 2017/2/4.
//  Copyright © 2017年 官辉. All rights reserved.
//

#import "MTRecordManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "lame.h"

@interface MTRecordManager ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    AVAudioSession *_audioSession;
    AVAudioRecorder *_audioRecoder;
    AVAudioPlayer *_audioPlayer;
    NSDictionary *_recordSetting;
    NSString *_filePathAndName;
    /**
     0   -   正常停止
     1   -   取消录音停止
     **/
    NSInteger _endRecordStatus;
    CFTimeInterval _startRecordTime;
    CFTimeInterval _endRecordTime;
}

//录音结束的回调block
@property (nonatomic, copy) void (^finishRecord) (NSString *filePathAndName, CGFloat duration);

//播放结束时的回调block
@property (nonatomic, copy) void (^finishPlay)();

@end

@implementation MTRecordManager

kSingletonM

- (instancetype)init{
    if (self = [super init]) {
        //初始化AVAudioRecord所需要的参数
        NSMutableDictionary *tempSetting = [NSMutableDictionary dictionary];
        
        //编码格式 kAudioFormatLinearPCM kAudioFormatMPEG4AAC
        tempSetting[AVFormatIDKey] = [NSNumber numberWithInt:kAudioFormatLinearPCM];
        
        //采样率       人耳的接收频率是20kHZ,所以采样率必须是40KHz以上
        tempSetting[AVSampleRateKey] = [NSNumber numberWithFloat:44100.0]; //44100.0
        
        //通道数
        tempSetting[AVNumberOfChannelsKey] = [NSNumber numberWithInt:2];
        
        //音频质量，采样质量
        tempSetting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityMax];
        
        _recordSetting = [NSDictionary dictionaryWithDictionary:tempSetting];
        
        CACurrentMediaTime();
    }
    return self;
}

- (NSInteger)checkAuthorization{
    NSInteger canRecord = 0;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            //没有询问是否开启麦克风
            MyLog(@"未知状态");
            canRecord = 0;
        }
            break;
        case AVAuthorizationStatusRestricted:
        {
            MyLog(@"未授权，家长限制");
            canRecord = 1;
        }
            break;
        case AVAuthorizationStatusDenied:
        {
            MyLog(@"用户未授权(曾今选择过拒绝)");
            canRecord = 2;
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            MyLog(@"用户授权");
            canRecord = 3;
        }
            break;
        default:
            break;
    }
    return canRecord;
}

#pragma mark - 录音
- (void)startRecord:(void (^)(NSString *, CGFloat audioDuration))finishRecord{
    if (!finishRecord) {
        MyLog(@"finishRecord不能为空");
        return;
    }
    _endRecordStatus = 0;
    self.finishRecord = finishRecord;
    //初始化AVAudioSession
    NSError *error = nil;
    _audioSession = [AVAudioSession sharedInstance];
//    [_audioSession setActive:YES error:&error];
    NSAssert(error == nil, @"FILE[%s]\tLINE:[%d]\tERROR:[%@]", __FILE__, __LINE__, error);
    [_audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    NSAssert(error == nil, @"FILE[%s]\tLINE:[%d]\tERROR:[%@]", __FILE__, __LINE__, error);
    
    MJWeakSelf;
    NSInteger check = [self checkAuthorization];
    if (check == 0) {
        //第一次申请
        [_audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                MyLog(@"允许");
                [weakSelf beginRecord];
            }
            else{
                MyLog(@"拒绝");
            }
        }];
    }else if (check == 1 || check == 2){
        //被拒绝过 需要用户手动开启
        MyLog(@"请手动开启");
        return;
    }else{
        [self beginRecord];
    }
}

- (void)beginRecord{
    NSError *error = nil;
    NSDate *date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString * currentTimeString = [formatter stringFromDate:date];
    
    _filePathAndName = @"";
    if ([self.filePath isExist]) {
        _filePathAndName = self.filePath;
    }else{
        _filePathAndName = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    }
    MyLog(@"[%@]", _filePathAndName);
    _filePathAndName = [_filePathAndName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",currentTimeString]];
    
    NSURL *recordUrl = [NSURL URLWithString:_filePathAndName];
    
    error = nil;
    _audioRecoder = [[AVAudioRecorder alloc] initWithURL:recordUrl settings:_recordSetting error:&error];
    if (error) {
        MyLog(@"RecordError:[%@]",error);
        NSAssert(NO, @"");
    }
    _audioRecoder.delegate = self;
    [_audioRecoder prepareToRecord];
    _startRecordTime = CACurrentMediaTime();
    [_audioRecoder record];
}

- (void)pasuRecord{
    if ([_audioRecoder isRecording]) {
        [_audioRecoder pause];
    }
}

- (void)resumeRecord{
    if (![_audioRecoder isRecording]) {
        [_audioRecoder prepareToRecord];
        [_audioRecoder record];
    }
}

- (void)endRecord{
    if ([_audioRecoder isRecording]) {
        _endRecordTime = CACurrentMediaTime();
        [_audioRecoder stop];
        _audioRecoder = nil;
    }
}

- (void)cancelRecord{
    _endRecordStatus = 1;
    self.finishRecord = nil;
    if ([_audioRecoder isRecording]) {
        [_audioRecoder stop];
    }
}

#pragma mark - 播放
- (void)playSound:(id)filePathAndNameOrData finishPlay:(void (^)())finisPlay{
    if (finisPlay == nil) {
        MyLog(@"播放回调不允许为空");
        return;
    }
    
    NSError *error = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [_audioSession setActive:YES error:&error];
    if(error){
        MyLog(@"播放错误说明%@", [error description]);
        return;
    }
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if(error){
        MyLog(@"播放错误说明%@", [error description]);
        return;
    }
    
    error = nil;
    if ([filePathAndNameOrData isKindOfClass:[NSData class]]) {
        //使用字节流进行播放
        _audioPlayer = [[AVAudioPlayer alloc] initWithData:filePathAndNameOrData error:&error];
    }else{
        //使用文件进行播放
#warning 判断文件是否存在
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePathAndNameOrData] error:&error];
    }
    if (error) {
        MyLog(@"初始化播放器:%@", [error description]);
        return;
    }
    _audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
}

- (void)pausePlay{
    if ([_audioPlayer isPlaying]) {
        [_audioPlayer pause];
    }
}

- (void)endPlay{
    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
}

#pragma mark - AVAudioRecord录音代理
//录音结束的代理
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag == YES && self.finishRecord != nil) {
        self.finishRecord(_filePathAndName, _endRecordTime - _startRecordTime);
        self.finishRecord = nil;
    }
    
    if (_endRecordStatus != 0) {
        MyLog(@"%ld", (long)_endRecordStatus);
        if (![_audioRecoder deleteRecording]) {
            MyLog(@"删除录音文件失败");
        }
    }
    _audioRecoder = nil;
    //中断结束
   [_audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

//录音被打断时
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
    [self endRecord];
}

//录音被打断结束时
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder {
    [self endRecord];
}

#pragma mark - AVAudioPlayer播放代理
//播放结束的代理方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag && self.finishPlay) {
        self.finishPlay();
        self.finishPlay = nil;
    }
    [_audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

//播放被打断时
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    [self endPlay];
}

//播放被打断结束时
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    [self endPlay];
}


#pragma mark - 转码
//pcm转成mp3格式
- (void)enCodePCM2Mp3:(NSString *)pcmFilePath outFile:(void (^)(NSString *mp3FilePath, NSData *outData))finishBlock {
    
    NSString *cafFilePath = pcmFilePath;
    NSMutableString *mp3FilePath = [NSMutableString stringWithString:pcmFilePath];
    [mp3FilePath replaceCharactersInRange:NSMakeRange(mp3FilePath.length-3, 3) withString:@"mp3"];
    NSLog(@"mp3FilePath : [%@]", mp3FilePath);
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil]){
        NSLog(@"删除原MP3文件");
    }
    
    @try {
        int read, write;
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100.0);
        lame_set_num_channels(lame,1);//设置1为单通道，默认为2双通道
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        finishBlock(mp3FilePath, [NSData dataWithContentsOfFile:mp3FilePath]);
    }
    return;
}
@end
