//
//  WJLogisticsCompanyModel.m
//  HuPlus
//
//  Created by reborn on 17/3/28.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJLogisticsCompanyModel.h"

@implementation WJLogisticsCompanyModel
- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.logisticsCompanyId = ToString(dic[@"logisticsId"]);
        self.logisticsCompanyName = ToString(dic[@"logisticsName"]);
        
    }
    return self;
}
@end
