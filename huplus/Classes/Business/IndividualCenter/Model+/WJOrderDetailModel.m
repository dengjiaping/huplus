//
//  WJOrderDetailModel.m
//  HuPlus
//
//  Created by reborn on 16/12/28.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJOrderDetailModel.h"
#import "WJOrderStoreModel.h"
@implementation WJOrderDetailModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.orderNo = ToString(dic[@"order_id"]);
        self.orderStatus = (OrderStatus)[dic[@"status"] integerValue];
        self.receiverName = ToString(dic[@"consignee"]);
        self.phoneNumber = ToString(dic[@"contacts"]);
        self.address = ToString(dic[@"address"]);
        self.countDown = [dic[@"order_out_itme"] integerValue];


        self.amount = ToString(dic[@"order_price"]);
        self.specialAmount = ToString(dic[@"amount"]);
        self.freightAmount = ToString(dic[@"reveling_price"]);
        self.PayAmount = ToString(dic[@"order_total"]);
        self.createTime = ToString(dic[@"create_date"]);
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *productDic in dic[@"order_store_list"]) {
            WJOrderStoreModel *orderStoreModel = [[WJOrderStoreModel alloc] initWithDic:productDic];
            [arr addObject:orderStoreModel];
        }
        self.orderStoreListArray = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
        
    }
    return self;
}

@end
