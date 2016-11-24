//
//  UIImage+Work.m
//  JianShu
//
//  Created by MenThu on 16/7/27.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "UIImage+Extension.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (Extension)


+ (UIImage *)resizeImage:(NSString *)imgName
{
    UIImage *img = [UIImage imageNamed:imgName];
    return [img stretchableImageWithLeftCapWidth:0.5 * img.size.width topCapHeight:0.5 * img.size.height];
}

+ (UIImage *)imageWithColor:(UIColor *)color Size:(CGSize)imageSize
{
    CGRect rect = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (void)analyzeGif2UIImage:(NSURL *)gifUrl returnData:(void(^)
                                                             (NSArray <UIImage *> *imageArray,
                                                              NSArray<NSNumber *> *timeArray,
                                                              NSArray <NSNumber *> *widths,
                                                              NSArray <NSNumber *> *heights,
                                                              CGFloat totalTime
                                                              ))returnBlock{
    if (returnBlock) {
        //通过文件的url来将gif文件读取为图片数据引用
        CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)gifUrl, NULL);
        //获取gif文件中图片的个数
        size_t count = CGImageSourceGetCount(source);
        //定义一个变量记录gif播放一轮的时间
        float allTime=0;
        //存放所有图片
        NSMutableArray * imageArray = [[NSMutableArray alloc]init];
        //存放每一帧播放的时间
        NSMutableArray * timeArray = [[NSMutableArray alloc]init];
        //存放每张图片的宽度 （一般在一个gif文件中，所有图片尺寸都会一样）
        NSMutableArray * widthArray = [[NSMutableArray alloc]init];
        //存放每张图片的高度
        NSMutableArray * heightArray = [[NSMutableArray alloc]init];
        //遍历
        for (size_t i=0; i<count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
//            [imageArray addObject:(__bridge UIImage *)(image)];
            [imageArray addObject: [UIImage imageWithCGImage: image]];
            CGImageRelease(image);
            //获取图片信息
            NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
            CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
            CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
            [widthArray addObject:[NSNumber numberWithFloat:width]];
            [heightArray addObject:[NSNumber numberWithFloat:height]];
            NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
            CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
            allTime+=time;
            [timeArray addObject:[NSNumber numberWithFloat:time]];
        }
        returnBlock(imageArray,timeArray,widthArray,heightArray,allTime);
    }
    return;
}

- (UIImage *)scaleImage:(CGSize)scaleSize{
    UIGraphicsBeginImageContext(scaleSize);  //size 为CGSize类型，即你所需要的图片尺寸
    [self drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}

@end
