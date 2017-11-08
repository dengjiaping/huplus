//
//  WJPriceListModel.m
//  HuPlus
//
//  Created by XT Xiong on 2017/2/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJPriceListModel.h"

@implementation WJPriceListModel



- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.minPrice = ToString(dic[@"min_price"]);
        self.maxPrice = ToString(dic[@"max_price"]);
    }
    return self;
}

@end
