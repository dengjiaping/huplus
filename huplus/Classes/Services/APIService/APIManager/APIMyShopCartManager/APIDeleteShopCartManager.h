//
//  APIDeleteShopCartManager.h
//  HuPlus
//
//  Created by reborn on 17/2/20.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIDeleteShopCartManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *cartId;

@end
