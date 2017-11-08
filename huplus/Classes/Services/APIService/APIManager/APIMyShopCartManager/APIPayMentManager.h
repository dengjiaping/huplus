//
//  APIPayMentManager.h
//  HuPlus
//
//  Created by XT Xiong on 2017/3/19.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIPayMentManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *orderId;
@property(nonatomic, strong)NSString *payType; //1.微信 2.支付宝 3.卡号

@end
