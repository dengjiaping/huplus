//
//  WJOrderShopModel.h
//  HuPlus
//
//  Created by reborn on 17/2/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJOrderShopModel : NSObject

@property(nonatomic,strong)NSString       *shopName;
@property(nonatomic,strong)NSString       *shopId;
@property(nonatomic,strong)NSString       *deliverId;   //配送方式
@property(nonatomic,strong)NSString       *deliverFee;  //配送费用

@property(nonatomic,strong)NSString     *couponName;      //优惠券
@property(nonatomic,strong)NSString     *couponId;
@property(nonatomic,strong)NSString     *couponAmount;    //优惠券面值

@property(nonatomic,strong)NSMutableArray *productArray;



- (id)initWithDic:(NSDictionary *)dic;
@end
