//
//  WJLogisticsListReformer.m
//  HuPlus
//
//  Created by reborn on 17/3/28.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJLogisticsListReformer.h"
#import "WJLogisticsCompanyModel.h"
@implementation WJLogisticsListReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data[@"logistics_list"] isKindOfClass:[NSArray class]]) {
        
        for (id obj in data[@"logistics_list"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                WJLogisticsCompanyModel *logisticsCompanyModel = [[WJLogisticsCompanyModel alloc] initWithDic:obj];
                [result addObject:logisticsCompanyModel];
                
            }
        }
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:data];
    
    [dataDic setValue:result forKey:@"logistics_list"];
    
    return dataDic;
}
@end
