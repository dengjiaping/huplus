//
//  WJSignCreateManager.m
//  WanJiCard
//
//  Created by Lynn on 15/12/15.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJSignCreateManager.h"
#import "NSString+CoculationSize.h"
#import "SecurityService.h"


@implementation WJSignCreateManager

+ (NSDictionary *)postSignWithDic:(NSMutableDictionary *)dict methodName:(NSString *)methodName
{
    NSArray * keys = [dict allKeys];
    NSArray * tempArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        if (result == NSOrderedSame) {
            result = [obj1 compare:obj2];
        }
        return result;
    }];
    
    NSMutableString * valueString = [NSMutableString string];
    NSMutableArray * valueArray = [NSMutableArray array];
    
    for(int i = 0; i < [tempArray count]; i++)
    {
        NSString * str = [dict objectForKey:[tempArray objectAtIndex:i]];
//        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [valueArray addObject:str];
        
    }
    
    valueString = (NSMutableString *)[valueArray componentsJoinedByString:@""];
    valueString = (NSMutableString *)[valueString stringByAppendingString:[NSString stringWithFormat:@"550a63dbba6933dfef5d6071083abc160ae7b45aaeff676527482f88ec6d3191"]];
    
    NSMutableString * sign = (NSMutableString *)@"";
    NSLog(@"sign:%@",valueString);
    sign = (NSMutableString *)[SecurityService md5ForString:valueString];
    
    return @{@"sign":[sign lowercaseString]};
}


+ (NSDictionary *)getSignWithDic:(NSMutableDictionary *)dict methodName:(NSString *)methodName
{
    
    NSArray * keys = [dict allKeys];
    NSArray * tempArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        if (result == NSOrderedSame) {
            result = [obj1 compare:obj2];
        }
        return result;
    }];
    
    NSMutableString * valueString = [NSMutableString string];
    NSMutableArray * valueArray = [NSMutableArray array];
    
    for(int i = 0; i < [tempArray count]; i++)
    {
        NSString * str = [dict objectForKey:[tempArray objectAtIndex:i]];
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [valueArray addObject:str];
    }
    
    valueString = (NSMutableString *)[valueArray componentsJoinedByString:@""];
    valueString = (NSMutableString *)[valueString stringByAppendingString:[NSString stringWithFormat:@"123456"]];

    NSMutableString * sign = (NSMutableString *)@"";
    sign = (NSMutableString *)[SecurityService md5ForString:valueString] ;

    return @{@"sign":sign};
    
}

+ (NSString *)createSingByDictionary:(NSDictionary *)dict
{
    NSArray * keys = [dict allKeys];
    NSArray * tempArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        // 如果有相同的姓，就比较名字
        if (result == NSOrderedSame) {
            result = [obj1 compare:obj2];
        }
        return result;
    }];
    
    NSMutableString * sign = (NSMutableString *)@"";
    NSMutableArray * valueArray = [NSMutableArray array];
    
    for(int i = 0; i < [tempArray count]; i++)
    {
        NSString * str = [dict objectForKey:[tempArray objectAtIndex:i]];
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [valueArray addObject:str];
        sign = (NSMutableString *)[sign stringByAppendingString:[NSString stringWithFormat:@"%@%@",[tempArray objectAtIndex:i],str]];
    }
    
    sign = (NSMutableString *)[SecurityService getSha1String:[sign lowercaseString]];
    
    sign = (NSMutableString *)[SecurityService stringWithBase64Str:sign];
    
    return sign;
}


+ (NSMutableString *)randomString
{
    return (NSMutableString *)[SecurityService stringWithBase64Str:@"020"];
}

+ (NSMutableString *)randomCharacter
{
    return (NSMutableString *)@"w";
}


@end
