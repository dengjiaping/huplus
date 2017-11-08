//
//  APIRefundProgressManager.h
//  HuPlus
//
//  Created by reborn on 17/3/29.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIRefundProgressManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property (nonatomic, strong) NSString    *userId;
@property (nonatomic, strong) NSString    *refundId;
@property (nonatomic, strong) NSString    *refundType;
@end
