//
//  WJIndividualCenterModel.h
//  HuPlus
//
//  Created by reborn on 17/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJIndividualCenterModel : NSObject

@property(nonatomic,assign)NSInteger noReadMessageCount;      //未读消息
@property(nonatomic,strong)NSArray  *orderCountArray;         //待付款、待发货、待收货、退款售后数量
@property(nonatomic,strong)NSArray  *collectionCountArray;    //我的收藏、我的优惠券数量

- (id)initWithDic:(NSDictionary *)dic;
@end
