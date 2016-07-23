//
//  MyLog.h
//  TestGitHub
//
//  Created by MenThu on 16/7/23.
//  Copyright © 2016年 官辉. All rights reserved.
//

#ifndef MyLog_h
#define MyLog_h


#ifdef DEBUG
#define MyLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define MyLog(...)
#endif

#endif /* MyLog_h */
