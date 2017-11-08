//
//  WJCouponListModel.m
//  HuPlus
//
//  Created by  on 17/2/23.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJCouponListModel.h"
#import "WJCouponModel.h"
@implementation WJCouponListModel
- (id)initWithDic:(NSDictionary *)dic
{
    self.totalCount   = [dic[@"total_page"] integerValue];
    self.noUseCount   = [dic[@"no_user_count"] integerValue];
    self.useCount     = [dic[@"user_count"] integerValue];
    self.expiredCount = [dic[@"overdue_count"] integerValue];
    
    NSMutableArray * resultsArray  = [NSMutableArray array];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSDictionary * result = [NSDictionary dictionary];
        result = [dic objectForKey:@"coupon_list"];
        for (id obj in result) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                WJCouponModel *couponModel = [[WJCouponModel alloc] initWithDic:obj];
                [resultsArray addObject:couponModel];
            }
        }
        self.couponListArray = [NSMutableArray arrayWithArray:resultsArray];
        
    }
    return self;
}
@end
