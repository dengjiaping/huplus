//
//  WJOrderDetailReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/28.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJOrderDetailReformer.h"
#import "WJOrderDetailModel.h"
@implementation WJOrderDetailReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJOrderDetailModel *orderDetailModel = [[WJOrderDetailModel alloc] initWithDic:data];
    
    return orderDetailModel;
}
@end
