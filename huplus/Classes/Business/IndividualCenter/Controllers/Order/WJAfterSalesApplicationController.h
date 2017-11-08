//
//  WJAfterSalesApplicationController.h
//  HuPlus
//
//  Created by reborn on 16/12/29.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import "WJMyOrderControllerDelegate.h"
#import "WJOrderDetailModel.h"
@interface WJAfterSalesApplicationController : WJViewController
@property(nonatomic,weak) id<WJMyOrderControllerDelegate> delegate;
@property(nonatomic,strong)WJRefreshTableView   *tableView;
@property(nonatomic,strong)WJOrderDetailModel   *detailOrder;


@end
