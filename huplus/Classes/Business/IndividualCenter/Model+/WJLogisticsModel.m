//
//  WJLogisticsModel.m
//  HuPlus
//
//  Created by reborn on 17/3/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJLogisticsModel.h"
#import "WJLogisticsDetailModel.h"
@implementation WJLogisticsModel
- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.orderNo = ToString(dic[@"logistics_no"]);
        self.logisticsName = ToString(dic[@"logistics_name"]);
        self.logisticsPhone = ToString(dic[@"logistics_phone"]);

        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *logisticsDic in dic[@"logistics_list"]) {
            WJLogisticsDetailModel *logisticsDetailModel = [[WJLogisticsDetailModel alloc] initWithDic:logisticsDic];
            [arr addObject:logisticsDetailModel];
        }
        self.listArray = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
    
    }
    return self;
}
@end
