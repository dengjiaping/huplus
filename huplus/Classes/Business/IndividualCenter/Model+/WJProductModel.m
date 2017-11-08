//
//  WJProductModel.m
//  HuPlus
//
//  Created by reborn on 17/1/8.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJProductModel.h"
#import "WJAttributeDetailModel.h"
@implementation WJProductModel
- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {

        self.productId = ToString(dic[@"goods_id"]);
        self.name      = ToString(dic[@"goods_name"]);
        self.imageUrl  = ToString(dic[@"head_pic"]);
        self.salePrice = ToString(dic[@"price"]);
        self.count     = [dic[@"count"] integerValue];
        self.productStatus = [dic[@"goods_status"] integerValue];
        self.brandId   = ToString(dic[@"brand_id"]);
        self.brandName = ToString(dic[@"brand_name"]);
        self.shopId    = ToString(dic[@"store_id"]);
        self.skuId     = ToString(dic[@"sku_id"]);
        self.cartId    = ToString(dic[@"cart_id"]);
        self.refundPrice = ToString(dic[@"refund_total"]);
        self.stock     = [dic[@"goods_number"] integerValue];
        self.logisticsCost = ToString(dic[@"logistics_cost"]);

        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *attributeDic in dic[@"attribute_list"]) {
            WJAttributeDetailModel *attributeDetailModel = [[WJAttributeDetailModel alloc] initWithDictionary:attributeDic];
            [arr addObject:attributeDetailModel];
        }
        self.attributeArray = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
    }
    return self;
}
@end
