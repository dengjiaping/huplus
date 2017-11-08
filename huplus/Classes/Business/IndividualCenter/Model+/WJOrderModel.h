//
//  WJOrderModel.h
//  HuPlus
//
//  Created by reborn on 16/12/22.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJOrderStoreModel.h"
@interface WJOrderModel : NSObject

@property(nonatomic,strong) NSString        *orderNo;
@property(nonatomic,assign) OrderStatus     orderStatus;
@property(nonatomic,strong) NSString        *shopId;
@property(nonatomic,strong) NSString        *shopName;
@property(nonatomic,assign) NSInteger       refundType; //1.退货退款 2.仅退款

@property(nonatomic,assign) NSInteger       totalCount;            //合计数量
@property(nonatomic,strong) NSString        *PayAmount;            //合计
@property(nonatomic,strong) NSString        *refundTime;
@property(nonatomic,strong) NSString        *refundId;
@property(nonatomic,strong)NSMutableArray   *productList;

- (id)initWithDic:(NSDictionary *)dic;
@end
