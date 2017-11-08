//
//  APIShopCartAttributeManager.h
//  HuPlus
//
//  Created by reborn on 17/2/20.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIShopCartAttributeManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *skuId;


@end
