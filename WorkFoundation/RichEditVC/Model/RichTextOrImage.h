//
//  RichTextOrImage.h
//  CGLearn
//
//  Created by MenThu on 16/7/13.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonHead.h"

@interface RichTextOrImage : NSObject

@property (nonatomic, copy)NSAttributedString *richText;
@property (nonatomic, strong)UIImage *photoImage;
@property (nonatomic, assign)CellType cellType;
@property (nonatomic, copy)NSIndexPath *indexPath;
@property (nonatomic,assign)CGFloat cellHeight;


@end
