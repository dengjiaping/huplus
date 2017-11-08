//
//  WJBrandDetailModel.h
//  HuPlus
//
//  Created by reborn on 17/2/25.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJBrandDetailModel : NSObject
@property(nonatomic,strong)NSString       *brandLogo;
@property(nonatomic,strong)NSString       *brandName;
@property(nonatomic,strong)NSString       *describe;
@property(nonatomic,strong)NSString       *onSaleCount;
@property(nonatomic,strong)NSMutableArray *listArray;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
