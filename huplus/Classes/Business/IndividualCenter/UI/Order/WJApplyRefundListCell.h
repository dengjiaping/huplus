//
//  WJApplyRefundListCell.h
//  HuPlus
//
//  Created by reborn on 17/4/20.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJProductModel.h"

@interface WJApplyRefundListCell : UITableViewCell

@property(nonatomic, strong)WJActionBlock applyRefundBlock;

- (void)configDataWithModel:(WJProductModel *)model isDetail:(BOOL)isDetail;

@end
