//
//  RichTextView.m
//  CGLearn
//
//  Created by MenThu on 16/6/29.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "RichTextView.h"
#import "InputView.h"
#import "AccessoryView.h"
#import "JZNewEmotion.h"
#import "JZTextAttachment.h"
#import "CameraManager.h"



#import "ZLPhoto.h"




@interface RichTextView ()<UITextViewDelegate>

@property (strong, nonatomic)InputView *emojiView;
@property (strong, nonatomic)AccessoryView *toolView;


@end

@implementation RichTextView

- (instancetype)init
{
    if (self = [super init]) {
        [self configUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [self configUI];
}

- (void)configUI
{
    //更改自己的输入框
    //    self.backgroundColor = [UIColor redColor];
    self.font = [UIFont systemFontOfSize:15];
    WeakSelf;
    AccessoryView *accessoryView = [AccessoryView loadView];
    accessoryView.block = ^(AddImageType type){
        [weakSelf resignFirstResponder];
        switch (type) {
            case addImage:
                weakSelf.inputView = weakSelf.emojiView;
                [weakSelf becomeFirstResponder];
                break;
            case addText:
                weakSelf.inputView = nil;
                [weakSelf becomeFirstResponder];
                break;
            case addPhoto:
                weakSelf.inputView = nil;
                [weakSelf presentViewController];
                break;
            default:
                break;
        }
        
    };
    InputView *inputView = [InputView loadView];
    self.emojiView = inputView;
    self.inputAccessoryView = accessoryView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addEmotion:) name:@"EmotionButtonDidClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteText:) name:@"DeleteBtnClick" object:nil];
}

- (void)presentViewController
{
    
    WeakSelf;
    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf presentPhotoVC];
    }];
    UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [weakSelf takePhotoVC];
    }];
    [alterVC addAction:cancelAction];
    [alterVC addAction:okAction1];
    [alterVC addAction:okAction2];
    
    id controllerVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [controllerVC presentViewController:alterVC animated:YES completion:nil];
}

- (void)takePhotoVC
{
    [[CameraManager shareInstance] takePhoto:^(UIImage* image) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AddPhoto object:nil userInfo:@{Camera:image,AddImageFromWhichTextView:@(self.viewTag)}];
    }];
}


//删除表情
- (void)deleteText:(NSNotification *)note
{
    NSMutableAttributedString *allString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    if (allString.length == 0) {
        return;
    }
    
    NSLog(@"%@", NSStringFromRange(self.selectedRange));
    NSRange deleteRange = self.selectedRange;
    if (self.selectedRange.length == 0) {
        deleteRange = NSMakeRange(self.selectedRange.location-1, 1);
    }
    
    
    [allString replaceCharactersInRange:deleteRange withAttributedString:[[NSAttributedString alloc] initWithString:@""]];
    self.attributedText = allString;
    self.selectedRange = NSMakeRange(deleteRange.location+1, 0);
}

//添加表情
-(void)addEmotion:(NSNotification *)note
{
    NSDictionary *dict = note.userInfo;
    JZNewEmotion *emotion = dict[@"emotion"];
    
    JZTextAttachment *emotionTextAttachment = [[JZTextAttachment alloc] init];
    emotionTextAttachment.code = emotion.code;
    emotionTextAttachment.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",emotion.file,emotion.url]];
    
    //原图尺寸
    CGFloat originalH = emotionTextAttachment.image.size.height;
    CGFloat originalW = emotionTextAttachment.image.size.width;
    
    CGFloat scale = originalH/originalW;
    CGFloat imageH = self.font.lineHeight;
    CGFloat imageW = imageH/scale;
    
    
    emotionTextAttachment.bounds = CGRectMake(0, 0, imageW, imageH);
    NSMutableAttributedString *emotionString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:emotionTextAttachment]];
    [emotionString insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:0];
    //获取光标现在的位置
    
    
    NSLog(@"%@",NSStringFromRange(self.selectedRange));
    NSUInteger location = self.selectedRange.location;
    NSMutableAttributedString *allString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [allString replaceCharactersInRange:self.selectedRange withAttributedString:emotionString];
    
    
    //重新赋值给响应者的富文本
    [allString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, allString.length)];
    self.attributedText = allString;
    //让光标重写回到插入位置的后面一个位置
    self.selectedRange=NSMakeRange(location+2, 0);
}


#pragma mark - ZLPhoto
- (void)presentPhotoVC
{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.maxCount = 9;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.isShowCamera = NO;
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        [[NSNotificationCenter defaultCenter] postNotificationName:AddPhoto object:nil userInfo:@{PhotoKey:status,AddImageFromWhichTextView:@(self.viewTag)}];
    };
    
    id controllerVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [pickerVc showPickerVc:controllerVC];
}



@end
