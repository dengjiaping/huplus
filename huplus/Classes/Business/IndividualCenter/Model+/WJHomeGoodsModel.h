//
//  WJHomeGoodsModel.h
//  HuPlus
//
//  Created by reborn on 16/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJHomeGoodsModel : NSObject
@property(nonatomic, strong)NSString *productId;
@property(nonatomic, strong)NSString *imgURL;
@property(nonatomic, strong)NSString *brandName;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *price;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
