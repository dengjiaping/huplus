//
//  WJHotSearchReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/21.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJHotSearchReformer.h"
#import "WJHotKeysModel.h"
@implementation WJHotSearchReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data[@"words_list"] isKindOfClass:[NSArray class]]) {
        
        for (id obj in data[@"words_list"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                WJHotKeysModel *hotKeysModel = [[WJHotKeysModel alloc] initWithDic:obj];
                [result addObject:hotKeysModel];
                
            }
        }
    }
    return result;
}
@end
