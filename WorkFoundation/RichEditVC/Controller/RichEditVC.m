//
//  RichEditVC.m
//  CGLearn
//
//  Created by MenThu on 16/7/14.
//  Copyright © 2016年 官辉. All rights reserved.
//
#import "CommonHead.h"
#import "RichEditVC.h"
#import "PhotoAndRichTextView.h"
#import "RichTextView.h"
#import "ZLPhoto.h"
#import "JZTextAttachment.h"
#import "CameraManager.h"
#import "NSDictionary+Convinience.h"
#import "Masonry.h"



#define NaviBarHeight 64

#define initRichTextViewHeight 150
#define initPhotoTextViewHeight 300
#define lastViewToScrollViewBottom 500
#define ViewBetweenView 0

@interface RichEditVC ()<UIScrollViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic)id firstRichView;

@property (assign, nonatomic)CGFloat keyBoardHeight;
@property (assign, nonatomic)CGFloat screenWidth;
@property (assign, nonatomic)CGFloat screenHeight;
@property (assign, nonatomic)CGFloat cursorToKeyBottomSpace;
@property (assign, nonatomic)CGFloat naviHeight;
@property (assign, nonatomic)CGFloat cursorTopSpace;

@property (strong, nonatomic)RichTextView *testView;

@property (strong, nonatomic)UIImageView *photoView;



@end

@implementation RichEditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"测试" style:UIBarButtonItemStylePlain target:self action:@selector(test)];
    
    
    self.cursorToKeyBottomSpace = self.cursorTopSpace = 50;
    self.naviHeight = 0;
    
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    [self registerNotification];
    [self addPhoto];
    
    
    
    self.photoView = [[UIImageView alloc] init];
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoView.clipsToBounds = YES;
    [self.view addSubview:self.photoView];

    self.photoView.frame = CGRectMake(self.screenWidth*0.1, self.screenHeight*0.5-100, self.screenWidth*0.8, 200);
    
}

- (void)takePhoto
{
    WeakSelf;
    [[CameraManager shareInstance] takePhoto:^(id image) {
        weakSelf.photoView.image = image;
    }];
}

- (void)test
{
    [self stringWithTextView:self.testView];
}

- (void)addPhoto
{
    RichTextView *view1 = [[RichTextView alloc] init];
    view1.viewTag = 0;
    view1.delegate = self;
    self.testView = view1;
    [self remakeConstraintWithArray:@[view1]];
}



- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPhotoRichText:) name:AddPhoto object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}


- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    if ([value CGRectValue].size.height <= 0) {
        return;
    }
    
    self.keyBoardHeight = [value CGRectValue].size.height;
    
    if ([self.firstRichView isKindOfClass:[PhotoAndRichTextView class]]) {
        [self performSelector:@selector(textViewDidChange:) withObject:[self.firstRichView richInputTextView] afterDelay:0.1f];
    }else{
        [self performSelector:@selector(textViewDidChange:) withObject:self.firstRichView afterDelay:0.1f];
    }
}

- (void)addPhotoRichText:(NSNotification *)center
{
    NSDictionary *dict = [center userInfo];
    NSInteger textViewTag = [dict[AddImageFromWhichTextView] integerValue];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    
    WeakSelf;
    if ([dict haveKey:PhotoKey]) {
        NSArray *imageArray = dict[PhotoKey];
        for (ZLPhotoAssets *model in imageArray) {
            PhotoAndRichTextView *addView = [PhotoAndRichTextView loadThisView];
            addView.deleteBlock = ^(PhotoAndRichTextView *deleteView){
                NSMutableArray *subViewsArray = [NSMutableArray arrayWithArray:weakSelf.scrollView.subviews];
                [subViewsArray removeObjectAtIndex:deleteView.viewTag];
                [weakSelf remakeConstraintWithArray:subViewsArray];
            };
            addView.richInputTextView.delegate = self;
            [addView setSelectImage:model.originImage];
            [tempArray addObject:addView];
        }
    }else if ([dict haveKey:Camera]){
        UIImage *addImage = dict[Camera];
        PhotoAndRichTextView *addView = [PhotoAndRichTextView loadThisView];
        addView.deleteBlock = ^(PhotoAndRichTextView *deleteView){
            NSMutableArray *subViewsArray = [NSMutableArray arrayWithArray:weakSelf.scrollView.subviews];
            [subViewsArray removeObjectAtIndex:deleteView.viewTag];
            [weakSelf remakeConstraintWithArray:subViewsArray];
        };
        addView.richInputTextView.delegate = self;
        [addView setSelectImage:addImage];
        [tempArray addObject:addView];
    }
    
    NSMutableArray *subViewsArray = [NSMutableArray arrayWithArray:self.scrollView.subviews];
    [subViewsArray insertObjects:tempArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(textViewTag+1, tempArray.count)]];
    
    //新增子视图
    [self remakeConstraintWithArray:subViewsArray];
}

- (void)remakeConstraintWithArray:(NSArray *)newSubViewsArray
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    WeakSelf;
    if (newSubViewsArray.count == 1) {
        //只有一个
        id subView = newSubViewsArray[0];
        [subView setViewTag:0];
        
        [self.scrollView addSubview:subView];
        [subView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.scrollView);
            make.left.equalTo(weakSelf.scrollView);
            make.right.equalTo(weakSelf.scrollView);
            make.width.equalTo(weakSelf.scrollView);
            make.height.mas_equalTo(initRichTextViewHeight);
            make.bottom.equalTo(weakSelf.scrollView).offset(-lastViewToScrollViewBottom);
        }];
    }else{
        //具有一个以上的子视图
        UIView *lastView = nil;
        for (NSInteger index = 0; index < newSubViewsArray.count; index++) {
            id subView = newSubViewsArray[index];
            [subView setViewTag:index];
            [self.scrollView addSubview:subView];
            
            CGFloat height = 0;
            if ([subView isKindOfClass:[PhotoAndRichTextView class]]) {
                PhotoAndRichTextView* view = (PhotoAndRichTextView *)subView;
                height = self.screenWidth / (view.photoImage.image.size.width / view.photoImage.image.size.height) + initRichTextViewHeight;
            }else{
                height = initRichTextViewHeight;
            }
            
            if (!index) {
                //第一个
                [subView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf.scrollView);
                    make.left.equalTo(weakSelf.scrollView);
                    make.right.equalTo(weakSelf.scrollView);
                    make.width.equalTo(weakSelf.scrollView);
                    make.height.mas_equalTo(height);
                }];
            }else if (index == newSubViewsArray.count-1){
                //最后一个
                [subView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).offset(ViewBetweenView);
                    make.left.equalTo(weakSelf.scrollView);
                    make.right.equalTo(weakSelf.scrollView);
                    make.height.mas_equalTo(height);
                    make.bottom.equalTo(weakSelf.scrollView).offset(-lastViewToScrollViewBottom);
                }];
            }else{
                //中间的视图
                [subView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).offset(ViewBetweenView);
                    make.left.equalTo(weakSelf.scrollView);
                    make.right.equalTo(weakSelf.scrollView);
                    make.height.mas_equalTo(height);
                }];
            }
            lastView = subView;
        }
    }
    return;
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.firstRichView = [self.scrollView.subviews objectAtIndex:[(RichTextView *)textView viewTag]];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //找寻UITextView的光标位置
    CGFloat cursorPosition;
    if (textView.selectedTextRange) {
        cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin.y;
    } else {
        cursorPosition = 0;
    }
    //为了精确的滚动到鼠标的位置，尤其在复制粘贴的时候，这句代码有作用
    CGRect cursorRowFrame = CGRectMake(0, cursorPosition, self.screenWidth, textView.font.lineHeight*2);
    [textView scrollRectToVisible:cursorRowFrame animated:NO];
    
    CGRect frameInScrollView = [self.scrollView convertRect:textView.frame fromView:textView.superview];
    CGFloat cursorToScrollTopSpace = frameInScrollView.origin.y + cursorPosition  - self.scrollView.contentOffset.y;
    CGFloat editFieldTopSpace = cursorToScrollTopSpace + self.cursorToKeyBottomSpace;
    CGFloat keyBoardTopSpace = self.screenHeight - self.naviHeight - self.keyBoardHeight;
    CGFloat offsetY = editFieldTopSpace - keyBoardTopSpace ;
    
    if (cursorToScrollTopSpace < 0) {
        //光标在屏幕顶端以上
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y+cursorToScrollTopSpace-self.cursorTopSpace-self.naviHeight) animated:YES];
    }else if(offsetY>0){
        //比较当前输入的实体的光标和键盘的位置
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + offsetY) animated:YES];
    }
    
    if (textView.bounds.size.height < textView.contentSize.height) {
        //更改约束的高度
        if ([self.firstRichView isKindOfClass:[PhotoAndRichTextView class]]) {
            [self.firstRichView mas_updateConstraints:^(MASConstraintMaker *make) {
                PhotoAndRichTextView *tempView = (PhotoAndRichTextView *)self.firstRichView;
                make.height.mas_offset(tempView.photoImage.bounds.size.height + textView.contentSize.height);
            }];
        }else{
            [self.firstRichView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(textView.contentSize.height);
            }];
        }
    }
}


#pragma mark - UIScrollDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (IBAction)quitEditTap:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - 解析富文本字符串
//富文本转字符串
-(NSString *)stringWithTextView:(UITextView *)textView
{
    NSMutableString *sentText = [NSMutableString string];
    [textView.attributedText enumerateAttributesInRange:NSMakeRange(0, textView.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        JZTextAttachment* textAttachement = attrs[@"NSAttachment"];
        NSLog(@"attrs : %@",attrs);
        if (textAttachement) {
            //表情
            [sentText insertString:textAttachement.code atIndex:0];
        }else
        {
            //文字
            [sentText insertString:[textView.attributedText attributedSubstringFromRange:range].string atIndex:0];
        }
    }];
    return sentText;
}

@end