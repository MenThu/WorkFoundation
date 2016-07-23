//
//  CommonHead.h
//  CGLearn
//
//  Created by MenThu on 16/7/13.
//  Copyright © 2016年 官辉. All rights reserved.
//

#ifndef CommonHead_h
#define CommonHead_h


typedef enum : NSUInteger {
    RichTextType,
    ImageType
} CellType;


typedef void(^ChangeFirstResponder)(id firstRespond,id firstRespondSuperView);
typedef void(^TextViewDidChange)(id firstRespond,id firstRespondSuperView,NSIndexPath *indexPath);

#define ScreenWith [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

typedef enum : NSUInteger {
    typeRecently,
    typeNormal,
    typeOther,
} EmojiType;


typedef enum : NSUInteger {
    addImage,
    addText,
    addPhoto
} AddImageType;

typedef void(^ChangeEmoji)(EmojiType type);
typedef void(^IsAddImageOrPhoto)(AddImageType type);

#define WeakSelf __weak __typeof__(self) weakSelf = self


#define Debug 1

#define FirstResponderChange @"changeResponder"
#define TextViewHeightChange @"TextViewHeightChange"
#define AddPhoto @"AddPhotoFromLibrary"
#define Camera @"AddPhotoFromCamera"
#define PhotoKey @"photoKey"
#define AddImageFromWhichTextView @"TextViewTag"

#endif 
