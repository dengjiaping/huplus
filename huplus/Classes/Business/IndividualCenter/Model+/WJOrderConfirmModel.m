//
//  WJOrderConfirmModel.m
//  HuPlus
//
//  Created by reborn on 17/2/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJOrderConfirmModel.h"
#import "WJOrderShopModel.h"
#import "WJCouponModel.h"
@implementation WJOrderConfirmModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.receiverName = ToString(dic[@"consignee"]);
        self.phoneNumber = ToString(dic[@"contacts"]);
        self.address = ToString(dic[@"address"]);
        self.couponName = ToString(dic[@"coupon_name"]);
        self.couponId = ToString(dic[@"coupon_id"]);
        self.receivingId = ToString(dic[@"receiving_id"]);
        self.couponAmount = ToString(dic[@"amount"]);


        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *productDic in dic[@"store_list"]) {
            WJOrderShopModel *orderShopModel = [[WJOrderShopModel alloc] initWithDic:productDic];
            [arr addObject:orderShopModel];
        }
        self.shopArray = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
    }
    return self;
}
@end
