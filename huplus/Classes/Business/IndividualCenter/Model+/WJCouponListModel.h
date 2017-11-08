//
//  WJCouponListModel.h
//  HuPlus
//
//  Created by reborn on 17/2/23.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCouponListModel : NSObject
@property (nonatomic, strong) NSMutableArray  *couponListArray;
@property (nonatomic, assign) NSInteger       totalCount;
@property (nonatomic, assign) NSInteger       noUseCount;
@property (nonatomic, assign) NSInteger       useCount;
@property (nonatomic, assign) NSInteger       expiredCount;

- (id)initWithDic:(NSDictionary *)dic;

@end
