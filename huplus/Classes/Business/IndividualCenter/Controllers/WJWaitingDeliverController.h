//
//  WJWaitingDeliverController.h
//  HuPlus
//
//  Created by reborn on 17/2/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import "WJMyOrderControllerDelegate.h"


@interface WJWaitingDeliverController : WJViewController
@property(nonatomic,strong)WJRefreshTableView *tableView;
@property(nonatomic,weak) id<WJMyOrderControllerDelegate> delegate;

@end
