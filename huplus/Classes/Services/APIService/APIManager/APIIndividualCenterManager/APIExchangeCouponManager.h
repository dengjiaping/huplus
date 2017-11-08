//
//  APIExchangeCouponManager.h
//  HuPlus
//
//  Created by XT Xiong on 2017/2/21.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIExchangeCouponManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString      * userId;
@property (nonatomic, assign) NSString      * couponCode;

@end
