//
//  APISubmitOrderManager.h
//  HuPlus
//
//  Created by reborn on 17/2/23.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APISubmitOrderManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *couponId;
@property(nonatomic, strong)NSString *receiveId;
@property(nonatomic, strong)NSString *totalAmount; //下单总金额
@property(nonatomic, strong)NSString *cartIdListString;
@property(nonatomic, strong)NSString *submitType; //1.购物车 2.立即购买

@property(nonatomic, strong)NSString *skuId;
@property(nonatomic, strong)NSString *shopId;
@property(nonatomic, assign)NSInteger goodsCount; //立即购买字段







@end
