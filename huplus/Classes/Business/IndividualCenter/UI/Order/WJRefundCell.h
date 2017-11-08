//
//  WJRefundCell.h
//  HuPlus
//
//  Created by reborn on 17/1/5.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJOrderModel.h"
@interface WJRefundCell : UITableViewCell

@property(nonatomic, strong)WJActionBlock checkProgress;
- (void)configDataWithOrder:(WJOrderModel *)orderModel;

@end
