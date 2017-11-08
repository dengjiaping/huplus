//
//  WJOrderStoreModel.h
//  HuPlus
//
//  Created by reborn on 17/2/27.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJOrderStoreModel : NSObject
@property(nonatomic,strong)NSString       *orderRelatedStoreId; //订单店铺关联Id
@property(nonatomic,strong)NSString       *shopId;
@property(nonatomic,strong)NSString       *shopName;
@property(nonatomic,strong)NSMutableArray *productList;

- (id)initWithDic:(NSDictionary *)dic;

@end
