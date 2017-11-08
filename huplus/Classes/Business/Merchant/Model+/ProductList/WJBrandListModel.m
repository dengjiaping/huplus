//
//  WJBrandListModel.m
//  HuPlus
//
//  Created by XT Xiong on 2017/2/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJBrandListModel.h"

@implementation WJBrandListModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.brandId = ToString(dic[@"brand_id"]);
        self.brandName = ToString(dic[@"brand_name"]);
    }
    return self;
}

@end
