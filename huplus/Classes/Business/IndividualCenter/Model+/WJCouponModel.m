//
//  WJCouponModel.m
//  HuPlus
//
//  Created by reborn on 16/12/25.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJCouponModel.h"

@implementation WJCouponModel
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if(self == [super init])
    {
        self.couponId = ToString(dic[@"coupon_id"]);
        self.name = ToString(dic[@"coupon_name"]);
        self.amount = ToString(dic[@"coupon_amount"]);
        self.couponDes = ToString(dic[@"full_amount"]);
        self.validTime = ToString(dic[@"end_date"]);
        self.startTime = ToString(dic[@"start_date"]);
        self.couponCurrentStatus = (CouponCurrentStatus)[dic[@"coupon_status"] intValue];
        self.couponType = (CouponType)[dic[@"coupon_type"] intValue];
        
    }
    return self;
}
@end
