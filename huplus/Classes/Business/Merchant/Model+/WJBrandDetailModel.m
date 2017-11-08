//
//  WJBrandDetailModel.m
//  HuPlus
//
//  Created by reborn on 17/2/25.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJBrandDetailModel.h"
#import "WJHomeGoodsModel.h"
@implementation WJBrandDetailModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.brandLogo   = ToString(dic[@"brand_logo"]);
        self.brandName   = ToString(dic[@"brand_name"]);
        self.describe   = ToString(dic[@"describe"]);
        self.onSaleCount   = ToString(dic[@"sale_count"]);
        if ([self.onSaleCount isEqualToString:@""]) {
            self.onSaleCount = @"0";
        }
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *productDic in dic[@"goods_list"]) {
            
            WJHomeGoodsModel *homeGoodsModel = [[WJHomeGoodsModel alloc] initWithDictionary:productDic];
            [arr addObject:homeGoodsModel];
        }
        self.listArray = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
        
    }
    return self;
}
@end
