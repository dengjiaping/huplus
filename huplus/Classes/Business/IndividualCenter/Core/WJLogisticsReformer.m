//
//  WJLogisticsReformer.m
//  HuPlus
//
//  Created by reborn on 17/3/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJLogisticsReformer.h"
#import "WJLogisticsModel.h"
@implementation WJLogisticsReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJLogisticsModel *logisticsModel = [[WJLogisticsModel alloc] initWithDic:data];
    return logisticsModel;
}
@end
