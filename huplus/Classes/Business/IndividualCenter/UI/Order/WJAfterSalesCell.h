//
//  WJAfterSalesCell.h
//  HuPlus
//
//  Created by reborn on 16/12/29.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WJOrderModel.h"
#import "WJProductModel.h"

@interface WJAfterSalesCell : UITableViewCell

@property(nonatomic, strong)WJActionBlock afterSaleApplyBlock;

//- (void)configDataWithOrder:(WJOrderModel *)model isDetail:(BOOL)isDetail;

- (void)configDataWithModel:(WJProductModel *)model isDetail:(BOOL)isDetail;


@end
