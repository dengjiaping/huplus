//
//  APICancelRefundManager.h
//  HuPlus
//
//  Created by reborn on 17/3/30.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APICancelRefundManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property (nonatomic, strong) NSString    *userId;
@property (nonatomic, strong) NSString    *refundId;
@end
