//
//  WJShopCartModel.m
//  HuPlus
//
//  Created by reborn on 17/2/8.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJShopCartModel.h"
#import "WJProductModel.h"
@implementation WJShopCartModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
    
        self.shopName = ToString(dic[@"store_name"]);
        self.shopId = ToString(dic[@"store_id"]);
        self.selectedCount = 0;


        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *productDic in dic[@"goods_list"]) {
            WJProductModel *productModel = [[WJProductModel alloc] initWithDic:productDic];
            [arr addObject:productModel];
        }
        self.productListArray = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
        
    }
    return self;
}
@end
