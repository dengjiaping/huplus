//
//  APIShopCartSettleManager.h
//  HuPlus
//
//  Created by reborn on 17/2/21.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIShopCartSettleManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *cartIdListString;
@property(nonatomic, strong)NSString *receiveId;


@end
