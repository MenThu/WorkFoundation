//
//  FileManager.h
//  FileManager
//
//  Created by MenThu on 16/8/11.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

FOUNDATION_EXTERN NSString* VoiceDocumentName;

@interface FileManager : NSObject

kSingletonH


/**
 *  检查文件是否存在
 *
 *  @param filePath 现在默认是检查 沙盒/Voice/下面的文件是否存在
 *
 *  @return 存在则返回为YES
 */
- (BOOL)isFileExist:(NSString *)fileName;


/**
 *  创建一个文件【可以包含路径名】【若文件存在不不会重复创建】
 *
 *  @param fileName  不能以"/"开头
 *
 *  @return 创建成功则返回YES
 */
- (BOOL)createFile:(NSString *)fileName;


/**
 *  删除以fileHead开头的文件
 *
 *  @param fileHead 文件头
 *
 *  @return 删除成功返回为YES
 */
- (BOOL)deleteFileWithHead:(NSString *)fileHead;


/**
 *  删除目录
 *
 *  @param dirPath 目录名
 *
 *  @return 删除成功则返回YES
 */
- (BOOL)deleteDir:(NSString *)dirPath;

//覆盖的方式写文件
- (BOOL)writeToFile:(NSString *)fileName WithContent:(id)content;


//追加的方式写文件
- (BOOL)appendDataToFile:(NSString *)fileName WithContent:(id)content;


- (NSString *)priMyPath;

@end
