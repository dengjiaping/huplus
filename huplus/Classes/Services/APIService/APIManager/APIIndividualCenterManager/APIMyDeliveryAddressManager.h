//
//  APIMyDeliveryAddressManager.h
//  HuPlus
//
//  Created by reborn on 17/2/22.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIMyDeliveryAddressManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString       *userId;
@property (nonatomic, assign) NSInteger      currentPage;      //当前页码
@property (nonatomic, assign) NSInteger      pageSize;         //每页条数
@end
