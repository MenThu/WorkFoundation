//
//  FileManager.m
//  FileManager
//
//  Created by MenThu on 16/8/11.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "FileManager.h"
#import "MyLog.h"


NSString const* VoiceDocumentName = @"/Voice/";

@interface FileManager ()


@property (nonatomic, strong) NSFileManager* myFileManager;
@property (nonatomic, copy) NSString* sanboxPath;
@property (nonatomic, copy) NSString* testPath;

@end

@implementation FileManager

kSingletonM

- (instancetype)init
{
    if (self = [super init]) {
        self.myFileManager = [NSFileManager defaultManager];
        self.sanboxPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:(NSString *)VoiceDocumentName];
        NSError *error = nil;
        if (![self.myFileManager fileExistsAtPath:self.sanboxPath]) {
            [self.myFileManager createDirectoryAtPath:self.sanboxPath withIntermediateDirectories:YES attributes:nil error:&error];
        }
        NSAssert(error==nil, @"%@",error);
        
    }
    return self;
}

- (BOOL)isFileExist:(NSString *)fileName
{
    return [self.myFileManager fileExistsAtPath:fileName];
//    return [self.myFileManager fileExistsAtPath:[self.sanboxPath stringByAppendingString:fileName]];
}


- (BOOL)createFile:(NSString *)fileName
{
    if ([self isFileExist:[self.sanboxPath stringByAppendingString:fileName]]) {
        return YES;
    }

    NSArray *pathArray = [fileName componentsSeparatedByString:@"/"];
    if (pathArray.count > 1) {
        //包含路径 先创建目录
        NSMutableString *pathString = [NSMutableString stringWithFormat:@"%@", self.sanboxPath];
        for (NSInteger index=0; index < pathArray.count-1; index++) {
            [pathString appendFormat:@"%@/",pathArray[index]];
        }
        NSLog(@"待创建的文件路径 : %@", pathString);
        NSError *error;
        if (![self.myFileManager createDirectoryAtPath:pathString withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"创建目录失败 : %@", error);
            return NO;
        }
    }
    return [self.myFileManager createFileAtPath:[self.sanboxPath stringByAppendingString:fileName] contents:nil attributes:nil];
}


- (BOOL)deleteFileWithHead:(NSString *)fileHead
{
    NSError *error = nil;
    NSArray* fileNameArray = [self.myFileManager contentsOfDirectoryAtPath:self.sanboxPath error:&error];
    if (error) {
        NSLog(@"读取目录失败 : %@", error);
        return NO;
    }else{
        for (NSString* fileName in fileNameArray) {
            if ([fileName hasPrefix:fileHead]) {
                error = nil;
                [self.myFileManager removeItemAtPath:[self.sanboxPath stringByAppendingString:fileName] error:&error];
                if (error) {
                    NSLog(@"删除[%@]出错[%@]", self.sanboxPath, error);
                    return NO;
                }
            }
        }
    }
    return YES;
}

- (BOOL)deleteDir:(NSString *)dirPath
{
    NSError *deleteErr = nil;
    [self.myFileManager removeItemAtPath:[self.sanboxPath stringByAppendingString:dirPath] error:&deleteErr];
    if (deleteErr) {
        NSLog(@"删除目录错误:[%@]", deleteErr);
        return NO;
    }
    return YES;
}

- (NSString *)priMyPath
{
    return [NSString stringWithFormat:@"%@",self.sanboxPath];
}

@end
