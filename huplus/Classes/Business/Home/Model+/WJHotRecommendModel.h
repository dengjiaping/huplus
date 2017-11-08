//
//  WJHotRecommendModel.h
//  HuPlus
//
//  Created by reborn on 17/2/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJHotRecommendModel : NSObject

@property(nonatomic, strong)NSString        *floorId;
@property(nonatomic, strong)NSString        *recommendName;
@property(nonatomic, strong)NSMutableArray  *productListArray;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
