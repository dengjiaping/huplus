//
//  WJOrderConfirmModel.h
//  HuPlus
//
//  Created by reborn on 17/2/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJOrderConfirmModel : NSObject

@property(nonatomic,strong)NSString     *receiverName;
@property(nonatomic,strong)NSString     *phoneNumber;
@property(nonatomic,strong)NSString     *address;
@property(nonatomic,strong)NSString     *receivingId;
@property(nonatomic,strong)NSArray      *shopArray;

@property(nonatomic,strong)NSString     *couponName;      //优惠券
@property(nonatomic,strong)NSString     *couponId;
@property(nonatomic,strong)NSString     *couponAmount;    //优惠券面值

- (id)initWithDic:(NSDictionary *)dic;

@end
