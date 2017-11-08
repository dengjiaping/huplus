//
//  WJProductDetailReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJProductDetailReformer.h"
#import "WJProductDetailModel.h"
@implementation WJProductDetailReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJProductDetailModel *productDetailModel = [[WJProductDetailModel alloc] initWithDictionary:data];
    
    return productDetailModel;
}
@end
