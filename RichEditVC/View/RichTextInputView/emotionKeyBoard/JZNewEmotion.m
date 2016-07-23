//
//  JZNewEmotion.m
//  Legendary
//
//  Created by jz100ios on 16/6/7.
//
//

#import "JZNewEmotion.h"

@implementation JZNewEmotion
//初始化
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.code = [aDecoder decodeObjectForKey:@"code"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.file = [aDecoder decodeObjectForKey:@"file"];
    }
    return self;
}

//存储
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.file forKey:@"file"];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", @{@"code":_code, @"url":_url}];
}

@end
