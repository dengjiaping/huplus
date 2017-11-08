//
//  WJMyDeliveryAddressViewController.h
//  HuPlus
//
//  Created by reborn on 16/12/27.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import "WJDeliveryAddressModel.h"

typedef NS_ENUM(NSInteger, FromVC){
    
    fromIndividualVC = 0,        // 个人中心
    fromOrderConfirmVC = 1,      // 确认订单
};

typedef void(^SelectAddressBlock)(WJDeliveryAddressModel *addressModel);

@interface WJMyDeliveryAddressViewController : WJViewController
@property(nonatomic,strong)SelectAddressBlock selectAddressBlock;
@property(nonatomic,assign)FromVC fromVC;

@end
