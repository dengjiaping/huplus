//
//  WJHomeGoodsModel.m
//  HuPlus
//
//  Created by reborn on 16/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJHomeGoodsModel.h"

@implementation WJHomeGoodsModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.productId     =ToString(dic[@"goods_id"]);
        self.brandName     = ToString(dic[@"brand_name"]);
        self.name          = ToString(dic[@"goods_name"]);
        self.imgURL        = ToString(dic[@"pic_url"]);
        self.price         = ToString(dic[@"price"]);
    }
    return self;
}
@end
