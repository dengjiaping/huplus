//
//  WJLogisticsDetailModel.h
//  HuPlus
//
//  Created by reborn on 17/3/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJLogisticsDetailModel : NSObject
@property(nonatomic,strong)NSString       *context;
@property(nonatomic,strong)NSString       *time;

- (id)initWithDic:(NSDictionary *)dic;

@end
