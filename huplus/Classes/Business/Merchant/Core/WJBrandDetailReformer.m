//
//  WJBrandDetailReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/25.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJBrandDetailReformer.h"
#import "WJBrandDetailModel.h"
@implementation WJBrandDetailReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJBrandDetailModel *brandDetailModel = [[WJBrandDetailModel alloc] initWithDictionary:data];
    return brandDetailModel;
}
@end
