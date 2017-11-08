//
//  WJThirdShopListModel.m
//  HuPlus
//
//  Created by reborn on 17/2/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJThirdShopListModel.h"

@implementation WJThirdShopListModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.imgUrl      = ToString(dic[@"first_pic"]);
        self.shopIconUrl = ToString(dic[@"store_pic"]);
        self.shopName    = ToString(dic[@"store_name"]);
        self.shopId      = ToString(dic[@"store_id"]);
        self.saleCount =  [dic[@"goods_count"] intValue];
        self.shopDetailUrl = ToString(dic[@"store_url"]);
        self.storeType = [dic[@"store_type"] intValue];
        
    }
    return self;
}
@end
