//
//  APIPayRightNowManager.h
//  HuPlus
//
//  Created by reborn on 17/2/28.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIPayRightNowManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *skuId;
@property (nonatomic, assign) NSInteger goodsCount;

@property (nonatomic, strong) NSString *receiveId;

@end
