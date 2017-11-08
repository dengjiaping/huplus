//
//  WJMyCouponViewController.h
//  HuPlus
//
//  Created by reborn on 16/12/25.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import "WJCouponModel.h"

typedef NS_ENUM(NSInteger, FromController){
    
    fromIndividualController = 0,        // 个人中心
    fromOrderConfirmController = 1,      // 确认订单
};

typedef void(^SelectCouponBlock)(WJCouponModel *couponModel);

@interface WJMyCouponViewController : WJViewController
@property(nonatomic,strong)SelectCouponBlock selectCouponBlock;

@property(nonatomic,assign)FromController fromVC;


@end
