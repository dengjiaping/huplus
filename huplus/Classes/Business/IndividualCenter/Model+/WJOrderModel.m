//
//  WJOrderModel.m
//  HuPlus
//
//  Created by reborn on 16/12/22.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJOrderModel.h"
#import "WJProductModel.h"
@implementation WJOrderModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.orderNo = ToString(dic[@"order_store_id"]);
        self.orderStatus = (OrderStatus)[dic[@"status"] intValue];
        self.PayAmount = ToString(dic[@"order_total"]);
        self.totalCount = [dic[@"goods_num"] integerValue];
        self.shopId = ToString(dic[@"store_id"]);
        self.shopName = ToString(dic[@"store_name"]);
        self.refundTime = ToString(dic[@"refund_time"]);
        self.refundId = ToString(dic[@"refund_id"]);
        self.refundType = [dic[@"type"] integerValue];


        
        NSMutableArray * resultsArray  = [NSMutableArray array];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSDictionary * result = [NSDictionary dictionary];
            result = [dic objectForKey:@"goods_list"];
            for (id obj in result) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    
                    WJProductModel *productModel = [[WJProductModel alloc] initWithDic:obj];
                    [resultsArray addObject:productModel];
                }
            }
            self.productList = [NSMutableArray arrayWithArray:resultsArray];
        }
    }
    return self;
}

@end
