//
//  APIOrderDetailRefundManager.h
//  HuPlus
//
//  Created by reborn on 17/3/20.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIOrderDetailRefundManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString    *userId;
@property (nonatomic, strong) NSString    *orderId;
@property (nonatomic, strong) NSString    *skuId;
@property (nonatomic, strong) NSString    *reason; //描述
@property (nonatomic, strong) NSString    *refundReason; //退货原因
@property (nonatomic, strong) NSString    *picListString;


@end
