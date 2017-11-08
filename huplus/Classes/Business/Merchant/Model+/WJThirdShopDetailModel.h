//
//  WJThirdShopDetailModel.h
//  HuPlus
//
//  Created by reborn on 17/2/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJThirdShopDetailModel : NSObject
@property(nonatomic, strong)NSString *imgUrl;
@property(nonatomic, strong)NSString *shopIconUrl;
@property(nonatomic, strong)NSString *shopName;
@property(nonatomic, strong)NSString *shopId;
@property(nonatomic, assign)NSInteger saleCount;
@property(nonatomic, assign)NSInteger totalPage;

@property(nonatomic,strong)NSMutableArray *productListArray;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
