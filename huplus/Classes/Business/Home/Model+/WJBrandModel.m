//
//  WJBrandModel.m
//  HuPlus
//
//  Created by reborn on 17/1/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJBrandModel.h"

@implementation WJBrandModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.imageUrl = ToString(dic[@"brand_pic"]);
        self.brandName = ToString(dic[@"brand_name"]);
        self.brandID = ToString(dic[@"brand_id"]);

    }
    return self;
}
@end
