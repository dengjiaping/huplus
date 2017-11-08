//
//  APIMyCouponManager.h
//  HuPlus
//
//  Created by reborn on 17/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIMyCouponManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property(nonatomic, strong) NSString    *userId;
@property(nonatomic, assign) NSInteger   currentPage;      //当前页码
@property(nonatomic, assign) NSInteger   pageSize;         //每页条数
@property(nonatomic, assign) CouponCurrentStatus couponCurrentStatus; //优惠券状态  1:未领取、2:已领取、3:未使用 4.已使用 5.已过期

@end
