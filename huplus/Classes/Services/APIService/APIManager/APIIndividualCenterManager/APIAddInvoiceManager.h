//
//  APIAddInvoiceManager.h
//  HuPlus
//
//  Created by reborn on 17/3/28.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIAddInvoiceManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property (nonatomic, strong) NSString    *userId;
@property (nonatomic, strong) NSString    *refundId;
@property (nonatomic, strong) NSString    *logisticsId;
@property (nonatomic, strong) NSString    *logisticsNo;
@property (nonatomic, strong) NSString    *logisticsName;

@end
