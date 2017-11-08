//
//  WJLogisticsDetailModel.m
//  HuPlus
//
//  Created by reborn on 17/3/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJLogisticsDetailModel.h"

@implementation WJLogisticsDetailModel
- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.context = ToString(dic[@"context"]);
        self.time = ToString(dic[@"time"]);
        
    }
    return self;
}
@end
