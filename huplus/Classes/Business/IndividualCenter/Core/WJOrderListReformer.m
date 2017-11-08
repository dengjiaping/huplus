//
//  WJOrderListReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/27.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJOrderListReformer.h"
#import "WJOrderListModel.h"

@implementation WJOrderListReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJOrderListModel *orderListModel = [[WJOrderListModel alloc] initWithDic:data];
    
    return orderListModel;
}
@end
