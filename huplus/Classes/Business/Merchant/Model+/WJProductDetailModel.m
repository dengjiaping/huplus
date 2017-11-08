//
//  WJProductDetailModel.m
//  HuPlus
//
//  Created by reborn on 17/2/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJProductDetailModel.h"
#import "WJHomeBannerModel.h"
#import "WJProductDescribeModel.h"
#import "WJAttributeModel.h"
@implementation WJProductDetailModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.productName  = ToString(dic[@"goods_name"]);
        self.productId    = ToString(dic[@"goods_id"]);
        self.skuId        = ToString(dic[@"sku_id"]);
        self.price        = ToString(dic[@"goods_price"]);
        self.originalPrice = ToString(dic[@"market_price"]);
        self.stock         = ToString(dic[@"goods_number"]);
        self.isColletion  = [dic[@"is_colletion"] boolValue];

        self.shopId       = ToString(dic[@"store_id"]);
        self.shopName     = ToString(dic[@"store_name"]);
        self.shopImgurl     = ToString(dic[@"store_icon"]);
        self.onSaleCount  =  [dic[@"store_goods_count"] intValue];
        
        self.productPic   = ToString(dic[@"goods_pic"]);
        self.detailUrl    = ToString(dic[@"link_url"]);

        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *productDic in dic[@"pic_list"]) {
            
            WJHomeBannerModel *homeBannerModel = [[WJHomeBannerModel alloc] initWithDictionary:productDic];
            [arr addObject:homeBannerModel];
        }
        self.bannerListArray = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
        
        
        for (NSDictionary *extendDic in dic[@"extend_list"]) {
            
            WJProductDescribeModel *productDescribeModel = [[WJProductDescribeModel alloc] initWithDictionary:extendDic];
            [arr addObject:productDescribeModel];
        }
        self.descriptionListArray = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
        
        
        for (NSDictionary *attributeDic in dic[@"attribute_list"]) {
            
            WJAttributeModel *attributeModel = [[WJAttributeModel alloc] initWithDictionary:attributeDic];
            [arr addObject:attributeModel];
        }
        self.attributeListArray = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
        
    }
    return self;
}
@end
