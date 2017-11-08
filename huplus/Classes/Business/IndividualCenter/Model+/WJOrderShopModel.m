//
//  WJOrderShopModel.m
//  HuPlus
//
//  Created by reborn on 17/2/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJOrderShopModel.h"
#import "WJProductModel.h"
@implementation WJOrderShopModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.shopName = ToString(dic[@"store_name"]);
        self.shopId = ToString(dic[@"store_id"]);
        self.deliverId = ToString(dic[@"logistics_id"]);
        self.deliverFee = ToString(dic[@"logistics_fee"]);
        
        self.couponName = ToString(dic[@"coupon_name"]);
        self.couponId = ToString(dic[@"coupon_id"]);
        self.couponAmount = ToString(dic[@"amount"]);

        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *productDic in dic[@"goods_list"]) {
            WJProductModel *productModel = [[WJProductModel alloc] initWithDic:productDic];
            [arr addObject:productModel];
        }
        self.productArray = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
        
    }
    return self;
}
@end
