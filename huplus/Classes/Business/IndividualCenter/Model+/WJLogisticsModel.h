//
//  WJLogisticsModel.h
//  HuPlus
//
//  Created by reborn on 17/3/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJLogisticsModel : NSObject
@property(nonatomic,strong)NSString       *orderNo;
@property(nonatomic,strong)NSString       *logisticsName;
@property(nonatomic,strong)NSString       *logisticsPhone;
@property(nonatomic,strong)NSMutableArray *listArray;

- (id)initWithDic:(NSDictionary *)dic;

@end
