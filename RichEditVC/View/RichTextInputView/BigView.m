




//
//  BigView.m
//  CGLearn
//
//  Created by MenThu on 16/7/1.
//  Copyright © 2016年 官辉. All rights reserved.
//

#define Width 100
#define gifImageViewToSelf 0.8

#import "BigView.h"
#import "CommonHead.h"
#import "UIImageView+Extension.h"

@interface BigView ()

@property (assign, nonatomic)CGFloat imageWidth;
@property (strong, nonatomic)UIImageView *gifImageView;

@end

@implementation BigView

+ (instancetype)shareInstance
{
    static id selfClassPoint = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        selfClassPoint = [[self alloc] init];
    });
    return selfClassPoint;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.image = [UIImage imageNamed:@"emotion"];
        self.bounds = CGRectMake(0, 0, Width, Width/(self.image.size.width/self.image.size.height));
        self.backgroundColor = [UIColor clearColor];
        self.image = [UIImage imageNamed:@"emotion"];
        
        UIImageView *emotionView = [[UIImageView alloc] init];
//        emotionView.backgroundColor = [UIColor redColor];
        emotionView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:emotionView];
        self.gifImageView = emotionView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gifImageView.frame = CGRectMake(3, 1, self.bounds.size.width-2*3,self.bounds.size.height-10);
}

-(void)showGifWithGifName:(NSString *)gitSting button:(UICollectionViewCell *)cell
{
    NSURL * url = [[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle] pathForResource:gitSting ofType:nil]];
    [self.gifImageView yh_setImage:url];
    
    NSLog(@"%@", self.subviews);
    
    CGRect newRect = [[UIApplication sharedApplication].windows.lastObject convertRect:cell.frame fromView:cell.superview];
    /**
     //    CGFloat frameW = self.frame.size.width;
     //    CGFloat frameH = self.frame.size.height;
     //    CGFloat frameX = newRect.origin.x - (frameW/2 - newRect.size.width/2);
     //    CGFloat frameY = newRect.origin.y - frameH - 10;
     **/
    CGFloat frameW = [UIScreen mainScreen].bounds.size.width*0.2;
    CGFloat frameH = frameW-5;
    CGFloat frameX = newRect.origin.x - (frameW/2 - newRect.size.width/2);
    CGFloat frameY = newRect.origin.y - frameW;
    self.frame = CGRectMake(frameX, frameY, frameW, frameH);
    
    [[UIApplication sharedApplication].windows.lastObject addSubview:self];
}

@end
