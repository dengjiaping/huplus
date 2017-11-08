//
//  WJShopCartModel.h
//  HuPlus
//
//  Created by reborn on 17/2/8.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJShopCartModel : NSObject

@property(nonatomic,strong)NSString *shopName;
@property(nonatomic,strong)NSString *shopId;

@property(nonatomic,assign)BOOL     isSelect;

@property(nonatomic,strong)NSMutableArray  *productListArray;
@property(nonatomic,assign)NSInteger       selectedCount; //记录该店铺下选中的商品

- (id)initWithDic:(NSDictionary *)dic;

@end
