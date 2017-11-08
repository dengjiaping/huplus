//
//  WJUnUsedCouponViewController.h
//  HuPlus
//
//  Created by reborn on 16/12/25.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import "WJRefreshTableView.h"
#import "WJCouponModel.h"
#import "WJMyCouponViewController.h"

typedef void(^SelectCouponBlock)(WJCouponModel *couponModel);

@interface WJUnUsedCouponViewController : WJViewController
@property(nonatomic,strong)WJRefreshTableView *tableView;
@property(nonatomic,strong)SelectCouponBlock selectCouponBlock;

@property(nonatomic,assign)FromController fromVC;

@end
