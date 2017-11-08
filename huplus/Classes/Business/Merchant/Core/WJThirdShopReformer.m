//
//  WJThirdShopReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/22.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJThirdShopReformer.h"
#import "WJThirdShopDetailModel.h"
@implementation WJThirdShopReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJThirdShopDetailModel *thirdShopDetailModel = [[WJThirdShopDetailModel alloc] initWithDictionary:data];
    return thirdShopDetailModel;
}
@end
