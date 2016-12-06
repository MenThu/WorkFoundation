//
//  MTBaseCell.m
//  TestStoryboard
//
//  Created by MenThu on 2016/11/21.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#import "MTBaseCell.h"
#define kBOUNCE_DISTANCE 3.f

@interface MTBaseCell ()

@property (nonatomic, strong,readwrite) UIButton *mtDeleteButton;

@end

@implementation MTBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.userInteractionEnabled = YES;
    [self configCell];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.userInteractionEnabled = YES;
        [self configCell];
    }
    return self;
}

- (void)configCell{
}

- (void)setCellModel:(id)cellModel{
    NSAssert([cellModel isKindOfClass:[MTBaseModel class]], @"cellModel必须为MTBaseModel的子类!");
    _cellModel = cellModel;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    if (state  == UITableViewCellStateShowingDeleteConfirmationMask)
    {
        UITableView *tableView = [self valueForKey:@"_tableView"];
        if (![tableView.delegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:)]) {
            return;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIView *swipeToDeleteConfirmationView = [self valueForKey:@"_swipeToDeleteConfirmationView"];
            
            for (UIButton *deleteButton in swipeToDeleteConfirmationView.subviews) {
                
                UITableViewRowAction *rowAction = [deleteButton valueForKey:@"_action"];
                deleteButton.enabled = rowAction.enabled;
                if (!deleteButton.enabled) {
                    deleteButton.backgroundColor = [UIColor lightGrayColor];
                }
                
                if (rowAction.image) {
                    CGFloat imageScale = rowAction.image.size.width / rowAction.image.size.height;
                    NSTextAttachment *imageAtt = [[NSTextAttachment alloc] init];
                    CGSize newImageSize = CGSizeMake(rowAction.imageWidth, rowAction.imageWidth/imageScale);
                    imageAtt.image = [rowAction.image scaleImage:newImageSize];
                    [deleteButton setAttributedTitle:[NSAttributedString attributedStringWithAttachment:imageAtt] forState:UIControlStateNormal];
                }
            }
        });
    }
}

@end
