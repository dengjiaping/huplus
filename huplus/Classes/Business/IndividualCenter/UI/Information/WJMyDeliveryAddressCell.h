//
//  WJMyDeliveryAddressCell.h
//  HuPlus
//
//  Created by reborn on 16/12/27.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJDeliveryAddressModel;

@interface WJMyDeliveryAddressCell : UITableViewCell
@property (nonatomic, strong) WJActionBlock settingDefaultAddressBlock;
@property (nonatomic, strong) WJActionBlock editAddressBlock;
@property (nonatomic, strong) WJActionBlock deleteAddressBlock;
-(void)configAddressdDataWithModel:(WJDeliveryAddressModel *)model;

@end
