//
//  WJGoodsListReformer.m
//  HuPlus
//
//  Created by XT Xiong on 2017/2/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJGoodsListReformer.h"
#import "WJHomeGoodsModel.h"

@implementation WJGoodsListReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:data];
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:dataDic[@"goods_list"]];
    for (int i = 0; i<dataArray.count; i++)
    {
        WJHomeGoodsModel *homeGoodsModel = [[WJHomeGoodsModel alloc]initWithDictionary:dataArray[i]];
        [dataArray replaceObjectAtIndex:i withObject:homeGoodsModel];
    }
    [dataDic setValue:dataArray forKey:@"goods_list"];
    return dataDic;
}
@end
