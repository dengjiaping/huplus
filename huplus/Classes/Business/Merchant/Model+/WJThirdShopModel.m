//
//  WJThirdShopModel.m
//  HuPlus
//
//  Created by reborn on 17/2/23.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJThirdShopModel.h"
#import "WJThirdShopListModel.h"
@implementation WJThirdShopModel
- (id)initWithDic:(NSDictionary *)dic
{
    self.totalPage   = [dic[@"total_page"] integerValue];
    
    NSMutableArray * resultsArray  = [NSMutableArray array];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSDictionary * result = [NSDictionary dictionary];
        result = [dic objectForKey:@"store_list"];
        for (id obj in result) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                WJThirdShopListModel *thirdShopListModel = [[WJThirdShopListModel alloc] initWithDictionary:obj];
                [resultsArray addObject:thirdShopListModel];
            }
        }
        self.shopListArray = [NSMutableArray arrayWithArray:resultsArray];
        
    }
    return self;
}
@end
