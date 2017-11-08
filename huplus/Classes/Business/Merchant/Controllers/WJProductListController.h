//
//  WJProductListController.h
//  HuPlus
//
//  Created by XT Xiong on 2016/12/26.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import "WJCategoryListModel.h"

typedef enum {
    ComeFromTypeHomeCategory,     //首页分类
    ComeFromTypeHomeMore,         //首页楼层更多
    ComeFromTypeBrandDetailMore,  //品牌详情更多
    ComeFromTypeSearch,           //搜索
    ComeFromTypeThirdShop,        //店铺装修
    ComeFromTypeBrand             //品牌more
}ComeFromType;

@interface WJProductListController : WJViewController

@property(nonatomic,strong)WJCategoryListModel      * homeCategoryListModel;
@property(nonatomic,strong)NSString                 * floorId;                  //楼层ID
@property(nonatomic,strong)NSString                 * condition;                //搜索关键字
@property(nonatomic,strong)NSString                 * brandName;                //品牌
@property(nonatomic,strong)NSString                 * brandId;                  //品牌ID
@property(nonatomic,strong)NSString                 * storeId;                  //店铺ID
@property(nonatomic,assign)ComeFromType               comeFormType;


@end
