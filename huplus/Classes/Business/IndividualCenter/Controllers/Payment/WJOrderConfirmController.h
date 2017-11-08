//
//  WJOrderConfirmController.h
//  HuPlus
//
//  Created by reborn on 17/1/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import "WJOrderConfirmModel.h"
#import "APIPayRightNowManager.h"

typedef NS_ENUM(NSInteger,OrderConfirmFromController){
    
    FromPayRightNow = 0,    //立即购买
    FromShopCart = 1,       //购物车
};

@interface WJOrderConfirmController : WJViewController
@property(nonatomic,strong)NSString                      *cardIdString;
@property(nonatomic,assign)OrderConfirmFromController    orderConfirmFromController;
@property(nonatomic,strong)APIPayRightNowManager         *payRightNowManager; //立即购买


@end
