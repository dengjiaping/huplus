//
//  WJMyShopCartReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/20.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJMyShopCartReformer.h"
#import "WJShopCartModel.h"
@implementation WJMyShopCartReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data[@"store_list"] isKindOfClass:[NSArray class]]) {
        
        for (id obj in data[@"store_list"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                WJShopCartModel *shopCartModel = [[WJShopCartModel alloc] initWithDic:obj];
                [result addObject:shopCartModel];
                
            }
        }
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:data];
    
    [dataDic setValue:result forKey:@"listArray"];
    [data setValue:data[@"tatal_page"] forKey:@"totalPage"];
    
    return dataDic;
}
@end
