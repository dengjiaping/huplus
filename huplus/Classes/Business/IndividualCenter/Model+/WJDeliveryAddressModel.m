//
//  WJDeliveryAddressModel.m
//  HuPlus
//
//  Created by reborn on 16/12/27.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJDeliveryAddressModel.h"

@implementation WJDeliveryAddressModel
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if(self == [super init])
    {
        self.name = ToString(dic[@"consignee"]);
        self.phone = ToString(dic[@"contacts"]);
        
        self.provinceName = ToString(dic[@"province_name"]);
        self.cityName = ToString(dic[@"city_name"]);
        self.districtName = ToString(dic[@"district_name"]);
        
        self.address = ToString(dic[@"address"]);
        self.detailAddress = ToString(dic[@"address"]);
        self.isDefaultAddress = [dic[@"is_default"] boolValue];
        
        self.receivingId = ToString(dic[@"receiving_id"]);
        
        self.provinceId = ToString(dic[@"province"]);
        self.cityId = ToString(dic[@"city"]);
        self.districtId = ToString(dic[@"district"]);


    }
    return self;
}

@end
