//
//  WJDeliveryAddressListModel.m
//  HuPlus
//
//  Created by reborn on 17/2/22.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJDeliveryAddressListModel.h"
#import "WJDeliveryAddressModel.h"
@implementation WJDeliveryAddressListModel
- (id)initWithDic:(NSDictionary *)dic
{
    self.totalPage = [dic[@"total_page"] intValue];

    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *productDic in dic[@"receiving_list"]) {
        WJDeliveryAddressModel *addressModel = [[WJDeliveryAddressModel alloc] initWithDic:productDic];
        [arr addObject:addressModel];
    }
    self.addresslistArray = [NSMutableArray arrayWithArray:arr];
    [arr removeAllObjects];
    
    return self;
}

@end
