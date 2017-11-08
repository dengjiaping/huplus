//
//  WJApplyRefundListController.h
//  HuPlus
//
//  Created by reborn on 17/4/20.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import "WJOrderDetailModel.h"

@interface WJApplyRefundListController : WJViewController
@property(nonatomic,strong)WJRefreshTableView   *tableView;
@property(nonatomic,strong)WJOrderDetailModel   *detailOrder;
@end
