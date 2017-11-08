//
//  WJOrderListModel.m
//  HuPlus
//
//  Created by reborn on 17/2/27.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJOrderListModel.h"
#import "WJOrderModel.h"
@implementation WJOrderListModel
- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.totalPage = [dic[@"total_page"] integerValue];
    
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *orderDic in dic[@"order_list"]) {
            WJOrderModel *orderModel = [[WJOrderModel alloc] initWithDic:orderDic];
            [arr addObject:orderModel];
        }
        self.orderList = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
    }
    return self;
}
@end
