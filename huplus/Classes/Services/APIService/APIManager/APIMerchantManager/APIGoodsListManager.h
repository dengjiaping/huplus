//
//  APIGoodsListManager.h
//  HuPlus
//
//  Created by XT Xiong on 2017/2/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIGoodsListManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString * categoryId;
@property (nonatomic, strong) NSString * brandId;
@property (nonatomic, strong) NSString * brandName;
@property (nonatomic, strong) NSString * minPrice;
@property (nonatomic, strong) NSString * maxprice;
@property (nonatomic, strong) NSString * condition;        //搜索关键字
@property (nonatomic, strong) NSString * storeId;          //店铺铺装修更多商品


@property (nonatomic, strong) NSString * currentPage;      //当前页码
@property (nonatomic, strong) NSString * pageSize;         //每页条数

@end
