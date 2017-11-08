//
//  APIAddShoppingCartManager.h
//  HuPlus
//
//  Created by reborn on 17/2/16.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIAddShoppingCartManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *skuId;
@property (nonatomic, assign) NSInteger productCount;



@end
