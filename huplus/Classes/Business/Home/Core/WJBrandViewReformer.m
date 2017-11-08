//
//  WJBrandViewReformer.m
//  HuPlus
//
//  Created by XT Xiong on 2017/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJBrandViewReformer.h"
#import "WJBrandModel.h"

@implementation WJBrandViewReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:data];
    NSMutableArray * listArray = [NSMutableArray arrayWithArray:dataDic[@"brand_list"]];
    for (int i = 0; i<listArray.count; i++) {
        WJBrandModel *brandModel = [[WJBrandModel alloc]initWithDic:listArray[i]];
        [listArray replaceObjectAtIndex:i withObject:brandModel];
    }
    [dataDic setValue:listArray forKey:@"brand_list"];
    return dataDic;
}

@end
