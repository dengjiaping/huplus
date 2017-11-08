//
//  WJCategoryListReformer.m
//  HuPlus
//
//  Created by XT Xiong on 2017/2/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJCategoryListReformer.h"
#import "WJCategoryListModel.h"

@implementation WJCategoryListReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{

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
    
    return categoryArray;
}

@end
