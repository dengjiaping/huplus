//
//  WJApplyRefundDetailController.h
//  HuPlus
//
//  Created by reborn on 17/4/20.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import "WJProductModel.h"
@interface WJApplyRefundDetailController : WJViewController
@property(nonatomic,strong)WJProductModel   *productModel;
@property(nonatomic,strong)NSString         *orderId;
@end
