//
//  WJCategoryListModel.m
//  HuPlus
//
//  Created by XT Xiong on 2017/2/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJCategoryListModel.h"

@implementation WJCategoryListModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.categoryId = ToString(dic[@"category_id"]);
        self.categoryPic = ToString(dic[@"category_pic"]);
        self.categoryName = ToString(dic[@"category_name"]);
        self.childListArray = dic[@"child_list"]?:[NSArray array];
    }
    return self;
}


@end
