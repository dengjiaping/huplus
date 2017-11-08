//
//  WJMyAllOrderController.h
//  HuPlus
//
//  Created by reborn on 16/12/21.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import "WJMyOrderControllerDelegate.h"

@interface WJMyAllOrderController : WJViewController

@property(nonatomic,weak) id<WJMyOrderControllerDelegate> delegate;
@property(nonatomic,strong)WJRefreshTableView *tableView;

@end
