//
//  APIDeleteDeliveryAddressManager.h
//  HuPlus
//
//  Created by reborn on 17/2/22.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIDeleteDeliveryAddressManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * receiveId;

@end
