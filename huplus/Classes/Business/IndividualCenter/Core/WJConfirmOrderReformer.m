//
//  WJConfirmOrderReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/21.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJConfirmOrderReformer.h"
#import "WJOrderConfirmModel.h"
@implementation WJConfirmOrderReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJOrderConfirmModel *orderConfirmModel = [[WJOrderConfirmModel alloc] initWithDic:data];
    
    return orderConfirmModel;
}
@end
