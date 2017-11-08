//
//  APIThirdShopDetailManager.h
//  HuPlus
//
//  Created by maying on 2017/6/28.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIThirdShopDetailManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString      *shopId;

@end
