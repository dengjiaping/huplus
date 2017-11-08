//
//  WJRefundPickerView.h
//  HuPlus
//
//  Created by reborn on 17/3/27.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJLogisticsCompanyModel.h"
@class WJRefundPickerView;

@protocol WJRefundPickerViewDelegate <NSObject>

-(void)refundPickerView:(WJRefundPickerView *)refundPickerView clickCancelButton:(UIButton *)cancelButton;

-(void)refundPickerView:(WJRefundPickerView *)refundPickerView clickConfirmButtonWithLogisticsCompanyModel:(WJLogisticsCompanyModel *)logisticsCompanyModel;

@end

@interface WJRefundPickerView : UIView
@property(nonatomic,weak)id <WJRefundPickerViewDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *expressListArray;

@end
