//
//  ScanManager.h
//  SZQRCodeViewController
//
//  Created by MenThu on 16/9/2.
//  Copyright © 2016年 StephenZhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef void(^ScanRezult)(id scanObject);

@interface ScanManager : NSObject

kSingletonH

//开始扫描
- (void)startScanWithView:(UIView *)scanView Rezult:(ScanRezult)scanBlock;

//结束扫描
- (void)endScan;

@end
