//
//  JZEmotionTool.m
//  Legendary
//
//  Created by jz100ios on 16/6/4.
//
//

typedef enum {
    JZEmotionTypeNormal,//最近使用表情
    JZEmotionTypePresent,//默认
    JZEmotionTypeOnion,//洋葱
    JZEmotionTypeStar//星星
} JZEmotionType;

#define PresentEmotionPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject ]stringByAppendingPathComponent: @"present_emotion.data"]

#import "JZEmotionTool.h"
#import "JZNewEmotion.h"

@interface JZEmotionTool ()

@property(nonatomic,strong)NSMutableArray *codeArray;

@property(nonatomic,strong)NSMutableArray *gitArray;

@property(nonatomic,assign)JZEmotionType type;

@end


@implementation JZEmotionTool
/**
 *  最近使用的表情
 */
static NSMutableArray *_presentEmotions;
/**
 *  默认表情
 */
static NSMutableArray *_normalEmotions;
/**
 *  洋葱表情
 */
static NSMutableArray *_onionEmotions;
/**
 *  星星表情
 */
static NSMutableArray *_starEmotions;




//临时存放code的数组
-(NSMutableArray *)codeArray
{
    if (_codeArray==nil) {
        _codeArray = [NSMutableArray array];
    }
    return _codeArray;
}


//临时存放git的数组
-(NSMutableArray *)gitArray
{
    if (_gitArray==nil) {
        _gitArray = [NSMutableArray array];
    }
    return _gitArray;
}



/**
 *  解析特殊节点
 */
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *str = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    if ([str containsString:@"{"]) {
        [self.codeArray addObject:str];
    }
    if ([str containsString:@".gif"]) {
        [self.gitArray addObject:str];
    }
}

/**
 *  结束解析
 */
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    for (int i = 0; i<self.codeArray.count; i++) {
        JZNewEmotion *emotion = [[JZNewEmotion alloc] init];
        emotion.code = self.codeArray[i];
        emotion.url = self.gitArray[i];
        switch (self.type) {
            case JZEmotionTypePresent:
                //默认
                [_normalEmotions addObject:emotion];
                break;
            case JZEmotionTypeOnion:
                //洋葱
                [_onionEmotions addObject:emotion];
                break;
            case JZEmotionTypeStar:
                //星星
                [_starEmotions addObject:emotion];
                break;
                
            default:
                break;
        }
    }
    self.codeArray = nil;
    self.gitArray = nil;
}

//获取默认表情
-(NSArray *)getNormalEmotions
{
    self.type = JZEmotionTypePresent;
    if (_normalEmotions==nil) {
        _normalEmotions = [NSMutableArray array];
        NSLog(@"%@",[NSBundle mainBundle]);
//        RichTextInputView/EmotionIcons/normal/discuz_smilies_normal.xml
        NSString *path = [[NSBundle mainBundle] pathForResource:@"/EmotionIcons/normal/discuz_smilies_normal.xml" ofType:nil];
        NSData *date = [NSData dataWithContentsOfFile:path];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:date];
        parser.delegate = self;
        [parser parse];
        //图片所存放的目录，这是属性会用在加载本地图片的时候
        [_normalEmotions makeObjectsPerformSelector:@selector(setFile:) withObject:@"EmotionIcons/normal/"];
    }
    return _normalEmotions;
}


//获取洋葱表情
-(NSArray *)getOnionEmotions
{
    self.type = JZEmotionTypeOnion;
    if (_onionEmotions==nil) {
        _onionEmotions = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/yangcong/discuz_smilies_onion.xml" ofType:nil];
        NSData *date = [NSData dataWithContentsOfFile:path];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:date];
        parser.delegate = self;
        [parser parse];
        //图片所存放的目录，这是属性会用在加载本地图片的时候
        [_onionEmotions makeObjectsPerformSelector:@selector(setFile:) withObject:@"EmotionIcons/yangcong/"];
    }
    return _onionEmotions;
}

//获取星星表情
-(NSArray *)getStarEmotions
{
    
    self.type = JZEmotionTypeStar;
    if (_starEmotions==nil) {
        _starEmotions = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/star/discuz_smilies_star.xml" ofType:nil];
        NSData *date = [NSData dataWithContentsOfFile:path];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:date];
        parser.delegate = self;
        [parser parse];
        //图片所存放的目录，这是属性会用在加载本地图片的时候
        [_starEmotions makeObjectsPerformSelector:@selector(setFile:) withObject:@"EmotionIcons/star/"];
    }
    return _starEmotions;
}


//最近使用表情数组
-(NSArray *)getPresentEmotion
{
    if (_presentEmotions==nil) {
        _presentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:PresentEmotionPath];
        if (_presentEmotions==nil) {
            _presentEmotions = [NSMutableArray array];
        }
    }
    return _presentEmotions;
}

//保存表情
-(void)savePresentEmotionWithEmotion:(JZNewEmotion *)emotion
{

    NSMutableArray *oldArray = [NSMutableArray arrayWithArray:[self getPresentEmotion]];
    
    for (JZNewEmotion *oldEmotion in oldArray) {
        if ([oldEmotion.code isEqualToString:emotion.code]) {
            [_presentEmotions removeObject:oldEmotion];
        }
    }
    [_presentEmotions insertObject:emotion atIndex:0];
    //最近使用表情不超过20个
    if (_presentEmotions.count>20) {
        [_presentEmotions removeLastObject];
    }
    [NSKeyedArchiver archiveRootObject:_presentEmotions toFile:PresentEmotionPath];
}


+ (instancetype)shareInstance
{
    static id selfClassPoint = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        selfClassPoint = [[self alloc] init];
    });
    return selfClassPoint;
}

@end
