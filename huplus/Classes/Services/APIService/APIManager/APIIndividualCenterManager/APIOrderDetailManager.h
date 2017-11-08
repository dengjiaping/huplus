//
//  APIOrderDetailManager.h
//  HuPlus
//
//  Created by reborn on 17/2/28.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIOrderDetailManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString    *userId;
@property (nonatomic, strong) NSString    *orderId;

@end
