//
//  WJPaymentModel.m
//  HuPlus
//
//  Created by reborn on 17/2/23.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJPaymentModel.h"

@implementation WJPaymentModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.accountBalance = ToString(dic[@"account_balance"]);
        self.orderId = ToString(dic[@"order_id"]);
        self.orderName = ToString(dic[@"order_name"]);
        self.orderTotal = ToString(dic[@"order_total"]);
        self.payMentType = ToString(dic[@"pay_type"]);

    }
    return self;
}


@end
