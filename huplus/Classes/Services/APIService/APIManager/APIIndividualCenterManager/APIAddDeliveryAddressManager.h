//
//  APIAddDeliveryAddressManager.h
//  HuPlus
//
//  Created by reborn on 17/2/22.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIAddDeliveryAddressManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *receiveId;
@property (nonatomic, strong) NSString *receiveName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *provinceId;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *districtId;

@property (nonatomic, strong) NSString *detailAddress;
@property (nonatomic, assign) NSInteger isDefault;
@property (nonatomic, assign) NSInteger operationType; //1.新增 2.修改




@end
