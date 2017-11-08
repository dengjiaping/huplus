//
//  WJAttributeModel.m
//  HuPlus
//
//  Created by reborn on 17/2/16.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJAttributeModel.h"
#import "WJAttributeDetailModel.h"
@implementation WJAttributeModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {

        self.attributeName   = ToString(dic[@"attr_name"]);

        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *attributeDic in dic[@"atrr_vlaue_list"]) {
            
            WJAttributeDetailModel *attributeDetailModel = [[WJAttributeDetailModel alloc] initWithDictionary:attributeDic];
            [arr addObject:attributeDetailModel];
        }
        self.listArray = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
        
    }
    return self;
}
@end
