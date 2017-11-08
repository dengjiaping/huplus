//
//  WJAttributeDetailModel.h
//  HuPlus
//
//  Created by reborn on 17/2/16.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJAttributeDetailModel : NSObject
@property(nonatomic,strong)NSString *attributeName;
@property(nonatomic,strong)NSString *valueName;
@property(nonatomic,strong)NSString *valueId;


@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *originalPrice;
@property(nonatomic,strong)NSString *skuId;
@property(nonatomic,strong)NSString *stock;

//@property(nonatomic,assign)BOOL   isSelected;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
