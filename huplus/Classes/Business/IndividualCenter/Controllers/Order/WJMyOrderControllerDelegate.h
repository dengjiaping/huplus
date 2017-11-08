//
//  WJMyOrderControllerDelegate.h
//  HuPlus
//
//  Created by reborn on 16/12/22.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#ifndef WJMyOrderControllerDelegate_h
#define WJMyOrderControllerDelegate_h
#import "WJOrderModel.h"

@protocol WJMyOrderControllerDelegate <NSObject>

@optional

-(void)payRightNowWithOrder:(WJOrderModel *)order;   //立即付款

-(void)checkLogisticseWithOrder:(WJOrderModel *)order; //检查物流

-(void)ConfirmReceiveWithOrder:(WJOrderModel *)order;//确认收货

-(void)CheckMoreWithOrder:(WJOrderModel *)order; //查看更多

-(void)cancelOrderWithOrder:(WJOrderModel *)orderDeliverModel; //取消订单

@end

#endif /* WJMyOrderControllerDelegate_h */
