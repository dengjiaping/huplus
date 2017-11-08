//
//  WJLogisticsCompanyModel.h
//  HuPlus
//
//  Created by reborn on 17/3/28.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJLogisticsCompanyModel : NSObject
@property(nonatomic,strong)NSString       *logisticsCompanyId;
@property(nonatomic,strong)NSString       *logisticsCompanyName;

- (id)initWithDic:(NSDictionary *)dic;
@end
