//
//  NSData+Convinience.m
//  Pods
//
//  Created by MenThu on 16/8/14.
//
//

#import "NSData+Convinience.h"

@implementation NSData (Convinience)

- (NSString *)convertToString
{
   return [[ NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)convertToDict
{
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
}


@end
