//
//  APIConfirmReceiveManager.h
//  HuPlus
//
//  Created by reborn on 17/3/1.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIConfirmReceiveManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString    *orderId;
@end
