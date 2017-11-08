//
//  APIBrandListManager.h
//  HuPlus
//
//  Created by XT Xiong on 2017/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIBrandListManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, assign) NSInteger   currentPage;      //当前页码
@property (nonatomic, assign) NSInteger   pageSize;         //每页条数

@end
