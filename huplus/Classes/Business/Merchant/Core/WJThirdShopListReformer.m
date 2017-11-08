//
//  WJThirdShopListReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/23.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJThirdShopListReformer.h"
#import "WJThirdShopListModel.h"
#import "WJThirdShopModel.h"
@implementation WJThirdShopListReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
//    WJThirdShopListModel *thirdShopListModel = [[WJThirdShopListModel alloc] initWithDictionary:data];
//    return thirdShopListModel;
    
    WJThirdShopModel *thirdShopModel = [[WJThirdShopModel alloc] initWithDic:data];
    return thirdShopModel;
}
@end
