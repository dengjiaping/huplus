//
//  WJIndividualCenterModel.m
//  HuPlus
//
//  Created by reborn on 17/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJIndividualCenterModel.h"

@implementation WJIndividualCenterModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.noReadMessageCount = [dic[@"news_num"] integerValue];
        
        NSString *collectionCount = dic[@"collection_num"];
        NSString *couponCount = dic[@"coupon_num"];
        
        NSString *pendingPaymentCount = dic[@"pending_payment"];
        NSString *deliverGoodsCount = dic[@"deliver_goods"];
        NSString *takeDeliveryCount = dic[@"take_delivery"];
        NSString *refundCount =  dic[@"refund_num"];


        NSMutableArray *results = [NSMutableArray array];
        [results addObject:pendingPaymentCount];
        [results addObject:deliverGoodsCount];
        [results addObject:takeDeliveryCount];
        [results addObject:refundCount];

        self.orderCountArray = [NSArray arrayWithArray:results];
        [results removeAllObjects];
        
        [results addObject:collectionCount];
        [results addObject:couponCount];
        self.collectionCountArray = [NSArray arrayWithArray:results];
        [results removeAllObjects];
        
    }
    
    return self;
}

@end
