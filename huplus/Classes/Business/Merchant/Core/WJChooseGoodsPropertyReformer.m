//
//  WJChooseGoodsPropertyReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/17.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJChooseGoodsPropertyReformer.h"
#import "WJAttributeDetailModel.h"
@implementation WJChooseGoodsPropertyReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data[@"sku_list"] isKindOfClass:[NSArray class]]) {
        
        for (id obj in data[@"sku_list"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                WJAttributeDetailModel *attributeDetailModel = [[WJAttributeDetailModel alloc] initWithDictionary:obj];
                [result addObject:attributeDetailModel];
                
            }
        }
    }
    return result;
}
@end
