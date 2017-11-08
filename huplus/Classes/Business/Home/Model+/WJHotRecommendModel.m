//
//  WJHotRecommendModel.m
//  HuPlus
//
//  Created by reborn on 17/2/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJHotRecommendModel.h"
#import "WJHomeGoodsModel.h"
@implementation WJHotRecommendModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.recommendName = ToString(dic[@"floor_name"]);
        self.floorId = ToString(dic[@"floor_id"]);
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *productDic in dic[@"goods_list"]) {
            WJHomeGoodsModel *homeGoodsModel = [[WJHomeGoodsModel alloc] initWithDictionary:productDic];
            [arr addObject:homeGoodsModel];
        }
        self.productListArray = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
       
    }
    return self;
}
@end
