//
//  WJThirdShopDetailModel.m
//  HuPlus
//
//  Created by reborn on 17/2/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJThirdShopDetailModel.h"
#import "WJHomeGoodsModel.h"
@implementation WJThirdShopDetailModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.imgUrl      = ToString(dic[@"first_pic"]);
        self.shopIconUrl = ToString(dic[@"store_pic"]);
        self.shopName    = ToString(dic[@"store_name"]);
        self.shopId    = ToString(dic[@"store_id"]);
        self.saleCount =  [dic[@"goods_count"] intValue];
        self.totalPage =  [dic[@"total_page"] intValue];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *productListDic in dic[@"goods_list"]) {
            
            WJHomeGoodsModel *homeGoodsModel = [[WJHomeGoodsModel alloc] initWithDictionary:productListDic];
            [arr addObject:homeGoodsModel];
        }
        self.productListArray = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
        
    }
    return self;
}
@end
