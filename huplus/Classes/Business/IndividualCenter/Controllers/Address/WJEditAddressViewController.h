//
//  WJEditAddressViewController.h
//  HuPlus
//
//  Created by reborn on 16/12/27.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import "WJDeliveryAddressModel.h"

/**
 *  页面类型
 */
typedef NS_ENUM(NSInteger, AddressViewType){
    
    AddressViewTypeNew = 0,         // 设置收货地址
    AddressViewTypeEdit = 1,       //  编辑修改地址
};

@interface WJEditAddressViewController : WJViewController
@property(nonatomic,strong)WJDeliveryAddressModel *deliveryAddressModel;
@property(nonatomic,assign)AddressViewType        addressViewType;
@end
