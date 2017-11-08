//
//  APIDeleteOrderManager.h
//  HuPlus
//
//  Created by reborn on 17/4/18.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIDeleteOrderManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString    *userId;
@property (nonatomic, strong) NSString    *orderId;
@end
