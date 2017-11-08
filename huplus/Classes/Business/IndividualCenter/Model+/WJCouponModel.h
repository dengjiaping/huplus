//
//  WJCouponModel.h
//  HuPlus
//
//  Created by reborn on 16/12/25.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCouponModel : NSObject

@property(nonatomic, strong) NSString *couponId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *amount;
@property(nonatomic, strong) NSString *couponDes;
@property(nonatomic, strong) NSString *startTime;
@property(nonatomic, strong) NSString *validTime;
@property(nonatomic, assign) CouponCurrentStatus couponCurrentStatus; //优惠券使用状态  1:未领取、2:已领取、3:未使用 4.已使用 5.已过期
@property(nonatomic, assign) CouponType couponType; //优惠券类型 1.通用券 2.满减券

//@property(nonatomic, assign) CouponSingleSelectBoxStatus singleSelectBoxStatus; //优惠券单选框显示状态
@property(nonatomic, assign) BOOL                        isSelect;        //优惠券是否被选中

- (instancetype)initWithDic:(NSDictionary *)dic;










@end
