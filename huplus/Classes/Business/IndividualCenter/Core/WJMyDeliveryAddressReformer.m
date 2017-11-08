//
//  WJMyDeliveryAddressReformer.m
//  HuPlus
//
//  Created by  on 17/2/22.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJMyDeliveryAddressReformer.h"
#import "WJDeliveryAddressModel.h"
#import "WJDeliveryAddressListModel.h"
@implementation WJMyDeliveryAddressReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJDeliveryAddressListModel *addressListModel = [[WJDeliveryAddressListModel alloc] initWithDic:data];
    
    return addressListModel;
}
@end
