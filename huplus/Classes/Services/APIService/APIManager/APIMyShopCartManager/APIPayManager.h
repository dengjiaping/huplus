//
//  APIPayManager.h
//  HuPlus
//
//  Created by reborn on 17/3/1.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIPayManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property(nonatomic, strong)NSString *orderId;
@property(nonatomic, strong)NSString *orderTotal;

@end
