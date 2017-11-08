//
//  APIMessageListManager.h
//  HuPlus
//
//  Created by reborn on 17/2/27.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIMessageListManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property (nonatomic, strong) NSString    *userId;
@property (nonatomic, strong) NSString    *messageType;     //1.系统消息 2.物流 3.我的资产
@property (nonatomic, assign) NSInteger   currentPage;      //当前页码
@property (nonatomic, assign) NSInteger   pageSize;         //每页条数
@end
