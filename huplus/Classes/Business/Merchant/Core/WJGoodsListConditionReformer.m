//
//  WJGoodsListConditionReformer.m
//  HuPlus
//
//  Created by XT Xiong on 2017/2/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJGoodsListConditionReformer.h"
#import "WJBrandListModel.h"
#import "WJPriceListModel.h"
#import "WJCategoryListModel.h"

@implementation WJGoodsListConditionReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:data];
    NSMutableArray * brandListArray = [NSMutableArray arrayWithArray:dataDic[@"brand_list"]];
    for (int i = 0; i < brandListArray.count; i++)
    {
        WJBrandListModel *brandModel = [[WJBrandListModel alloc]initWithDic:brandListArray[i]];
        [brandListArray replaceObjectAtIndex:i withObject:brandModel];
    }
    //插入全部品牌
    WJBrandListModel *brandModel = [[WJBrandListModel alloc]initWithDic:@{@"brand_id":@"",
                                                                          @"brand_name":@"全部品牌"}];
    [brandListArray insertObject:brandModel atIndex:0];
    
    NSMutableArray * categoryArray = [NSMutableArray arrayWithArray:data[@"category_list"]];
    for (int i = 0; i<categoryArray.count; i++)
    {
        WJCategoryListModel *categoryListModel = [[WJCategoryListModel alloc]initWithDic:categoryArray[i]];
        for (int i = 0; i<categoryListModel.childListArray.count; i++)
        {
            WJCategoryListModel *middleListModel = [[WJCategoryListModel alloc]initWithDic:categoryListModel.childListArray[i]];
            for (int i = 0; i<middleListModel.childListArray.count; i++)
            {
                WJCategoryListModel *childListModel = [[WJCategoryListModel alloc]initWithDic:middleListModel.childListArray[i]];
                [middleListModel.childListArray replaceObjectAtIndex:i withObject:childListModel];
            }
            [categoryListModel.childListArray replaceObjectAtIndex:i withObject:middleListModel];
        }
        [categoryArray replaceObjectAtIndex:i withObject:categoryListModel];
    }
    //插入全部分类
    WJCategoryListModel *middleListModel = [[WJCategoryListModel alloc]initWithDic:@{@"category_id":@"",
                                                                                     @"category_pic":@"",
                                                                                     @"category_name":@"全部分类",
                                                                                     @"child_list":@""}];
    [categoryArray insertObject:middleListModel atIndex:0];
    
    NSMutableArray * priceListArray = [NSMutableArray arrayWithArray:dataDic[@"price_list"]];
    for (int i = 0; i < priceListArray.count; i++)
    {
        //全部价格在tableview select中处理
        WJPriceListModel *priceListModel = [[WJPriceListModel alloc]initWithDic:priceListArray[i]];
        [priceListArray replaceObjectAtIndex:i withObject:priceListModel];
    }
    [dataDic setValue:brandListArray forKey:@"brand_list"];
    [dataDic setValue:categoryArray forKey:@"category_list"];
    [dataDic setValue:priceListArray forKey:@"price_list"];
    return dataDic;
}
@end
