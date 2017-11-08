//
//  WJOrderCell.h
//  HuPlus
//
//  Created by reborn on 16/12/21.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJOrderModel.h"

@interface WJOrderCell : UITableViewCell
@property(nonatomic, strong)WJActionBlock payRightNowBlock;
@property(nonatomic, strong)WJActionBlock ConfirmReceiveBlock;
@property(nonatomic, strong)WJActionBlock checkLogisticseBlock;
@property(nonatomic, strong)WJActionBlock cancelOrderBlock;
@property(nonatomic, strong)WJActionBlock checkMoreBlock;
@property(nonatomic, strong)WJActionBlock tapShopBlock;

- (void)configDataWithOrder:(WJOrderModel *)model;  //全部、待支付订单
@end
