//
//  WJMyCollectionModel.m
//  HuPlus
//
//  Created by reborn on 17/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJMyCollectionModel.h"
#import "WJHomeGoodsModel.h"

@implementation WJMyCollectionModel

- (id)initWithDic:(NSDictionary *)dic
{
    NSMutableArray * resultsArray  = [NSMutableArray array];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSDictionary * result = [NSDictionary dictionary];
        result = [dic objectForKey:@"goods_list"];
        for (id obj in result) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                WJHomeGoodsModel *productModel = [[WJHomeGoodsModel alloc] initWithDictionary:obj];
                [resultsArray addObject:productModel];
            }
        }
        self.collectionListArray = [NSMutableArray arrayWithArray:resultsArray];
        self.totalCount   = [dic[@"total_page"] intValue];
        
    }
    return self;
}
@end
