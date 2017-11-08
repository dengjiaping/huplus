//
//  WJRecommendReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJRecommendReformer.h"
#import "WJHotRecommendModel.h"

@implementation WJRecommendReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data[@"floor_list"] isKindOfClass:[NSArray class]]) {
        
        for (id obj in data[@"floor_list"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                WJHotRecommendModel *hotRecommendModel = [[WJHotRecommendModel alloc] initWithDic:obj];
                [result addObject:hotRecommendModel];
                
            }
        }
    }
    return result;
}
@end
