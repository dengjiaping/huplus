//
//  WJOrderStoreModel.m
//  HuPlus
//
//  Created by reborn on 17/2/27.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJOrderStoreModel.h"
#import "WJProductModel.h"
@implementation WJOrderStoreModel
- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.orderRelatedStoreId = ToString(dic[@"order_store_id"]);
        self.shopId = ToString(dic[@"store_id"]);
        self.shopName = ToString(dic[@"store_name"]);

        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *productDic in dic[@"goods_list"]) {
            WJProductModel *productModel = [[WJProductModel alloc] initWithDic:productDic];
            [arr addObject:productModel];
        }
        self.productList = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
    }
    return self;
}
@end
