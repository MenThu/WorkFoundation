//
//  KeyBoadrView.m
//  CGLearn
//
//  Created by MenThu on 16/6/29.
//  Copyright © 2016年 官辉. All rights reserved.
//

#import "KeyBoadrView.h"
#import "EmojiCell.h"
#import "CommonHead.h"
#import "JZNewEmotion.h"
#import "BigView.h"
#import "JZEmotionTool.h"


#define Row 8
#define RowFor4S 6

@interface KeyBoadrView ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic)UICollectionView *collectionView;

//每行间距
@property (assign, nonatomic)CGFloat lineSpace;
//列间距
@property (assign, nonatomic)CGFloat columSpace;
//每行个数
@property (assign, nonatomic)NSInteger howManyInaRow;
//宽高比例
@property (assign, nonatomic)CGFloat widthHeightScale;

@property (assign, nonatomic)CGFloat collectionViewCellWidht;

@property (strong, nonatomic)UIButton *deleteBtn;

@end

@implementation KeyBoadrView

- (void)awakeFromNib
{
    [self configUI];
}

- (void)configUI
{
    self.howManyInaRow = Row;
    
    if (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeFromString(@"{320, 480}"))) {
        self.howManyInaRow = RowFor4S;
    }
    
    
    self.lineSpace = 15;
    self.columSpace = 15;
    self.widthHeightScale = 1;
    
    
    
    
    //根据间距来计算每个cell的宽度
    CGFloat cellWidth = (ScreenWith - (self.howManyInaRow + 1)*self.columSpace) /(CGFloat)self.howManyInaRow;
    CGFloat cellHeight = cellWidth/self.widthHeightScale;
    self.collectionViewCellWidht = cellWidth;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = self.lineSpace;
    layout.minimumInteritemSpacing = self.columSpace;
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    
    NSLog(@"size : %@", NSStringFromCGSize(layout.itemSize));
    
    layout.sectionInset = UIEdgeInsetsMake(self.lineSpace, self.columSpace, self.lineSpace, self.columSpace);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];

    
    WeakSelf;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [collectionView registerNib:[UINib nibWithNibName:@"EmojiCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    
    
    UILongPressGestureRecognizer* longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    [self.collectionView addGestureRecognizer:longPressGr];
    [self.collectionView reloadData];
    
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.deleteBtn.imageView.clipsToBounds = YES;
    [self.deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteEmojiAct:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(cellWidth, cellHeight));
        make.top.equalTo(weakSelf.collectionView).offset(weakSelf.lineSpace);
        make.right.equalTo(weakSelf.collectionView).offset(-weakSelf.columSpace);
    }];
}

- (void)deleteEmojiAct:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DeleteBtnClick" object:nil userInfo:nil];
    return;
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath){
        EmojiCell* cell = (EmojiCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        [[BigView shareInstance] showGifWithGifName:[NSString stringWithFormat:@"%@%@", cell.model.file, cell.model.url] button:cell];
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [[BigView shareInstance] removeFromSuperview];
    }
}

- (void)setEmojiArray:(NSArray *)emojiArray
{
    JZNewEmotion *model = [JZNewEmotion new];
    model.file = @"";
    model.url = @"";
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:emojiArray];
    
    
    NSInteger index = Row-1;
    if (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeFromString(@"{320, 480}"))) {
        index = RowFor4S - 1;
    }
    
    [tempArray insertObject:model atIndex:index];
    _emojiArray = tempArray;
    
    [self.collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%ld", (long)self.emojiArray.count);
    return (self.emojiArray.count > 0 ? self.emojiArray.count : 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JZNewEmotion *emotion = self.emojiArray[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EmotionButtonDidClick" object:nil userInfo:@{@"emotion":emotion}];
    
    
    [[JZEmotionTool shareInstance] savePresentEmotionWithEmotion:emotion];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JZNewEmotion *model = self.emojiArray[indexPath.row];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", model.file, model.url]];
    if (image) {
        CGFloat scale = image.size.width / image.size.height;
        return CGSizeMake(self.collectionViewCellWidht, self.collectionViewCellWidht/scale);
    }else{
        return CGSizeMake(self.collectionViewCellWidht, self.collectionViewCellWidht);
    }
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    EmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.model = self.emojiArray[indexPath.row];
    return cell;
}


@end
