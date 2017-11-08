//
//  WJPriceListModel.h
//  HuPlus
//
//  Created by XT Xiong on 2017/2/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJPriceListModel : NSObject

@property(nonatomic,strong)NSString         *minPrice;
@property(nonatomic,strong)NSString         *maxPrice;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
