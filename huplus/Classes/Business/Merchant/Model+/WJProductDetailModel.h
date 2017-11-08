//
//  WJProductDetailModel.h
//  HuPlus
//
//  Created by reborn on 17/2/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJProductDetailModel : NSObject

@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSString *productId;
@property(nonatomic,strong)NSString *skuId;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *originalPrice;
@property(nonatomic,strong)NSString *stock;
@property(nonatomic,assign)BOOL     isColletion;

@property(nonatomic,strong)NSString *shopId;
@property(nonatomic,strong)NSString *shopName;
@property(nonatomic,strong)NSString *shopImgurl;
@property(nonatomic,assign)NSInteger onSaleCount;
@property(nonatomic,strong)NSString *detailUrl;

@property(nonatomic,strong)NSString       *productPic;
@property(nonatomic,strong)NSMutableArray *attributeListArray; //属性
@property(nonatomic,strong)NSMutableArray *descriptionListArray; //描述
@property(nonatomic,strong)NSMutableArray *bannerListArray;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
