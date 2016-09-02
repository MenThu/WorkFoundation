//
//  QRcodeManager.m
//  QRcode_GHdemo
//
//  Created by MenThu on 16/9/2.
//  Copyright © 2016年 Hope. All rights reserved.
//

#import "QRcodeManager.h"
#import "KMQRCode.h"
#import "UIImage+RoundedRectImage.h"

@implementation QRcodeManager

+ (UIImage *)createORImageWithInfo:(NSString *)ORString andSize:(CGSize)ORImageSize centerIcon:(UIImage *)centerImage
{
    NSString *source = ORString;
    
    //使用iOS 7后的CIFilter对象操作，生成二维码图片imgQRCode（会拉伸图片，比较模糊，效果不佳）
    CIImage *imgQRCode = [KMQRCode createQRCodeImage:source];
    
    //使用核心绘图框架CG（Core Graphics）对象操作，进一步针对大小生成二维码图片imgAdaptiveQRCode（图片大小适合，清晰，效果好）
    UIImage *imgAdaptiveQRCode = [KMQRCode resizeQRCodeImage:imgQRCode
                                                    withSize:ORImageSize.width];
    
    //默认产生的黑白色的二维码图片；我们可以让它产生其它颜色的二维码图片，例如：蓝白色的二维码图片
    imgAdaptiveQRCode = [KMQRCode specialColorImage:imgAdaptiveQRCode
                                            withRed:33.0
                                              green:114.0
                                               blue:237.0]; //0~255
    
    //使用核心绘图框架CG（Core Graphics）对象操作，创建带圆角效果的图片
    UIImage *imgIcon = [UIImage createRoundedRectImage:centerImage
                                              withSize:CGSizeMake(30, 30)
                                            withRadius:10];
    //使用核心绘图框架CG（Core Graphics）对象操作，合并二维码图片和用于中间显示的图标图片
    imgAdaptiveQRCode = [KMQRCode addIconToQRCodeImage:imgAdaptiveQRCode
                                              withIcon:imgIcon
                                          withIconSize:imgIcon.size];
    return imgAdaptiveQRCode;
}

@end
