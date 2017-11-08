//
//  APIMyCollectionManager.h
//  HuPlus
//
//  Created by reborn on 17/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIMyCollectionManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property (nonatomic, assign) NSInteger   currentPage;      //当前页码
@property (nonatomic, assign) NSInteger   pageSize;         //每页条数
@property (nonatomic, strong) NSString    *userId;
@end
