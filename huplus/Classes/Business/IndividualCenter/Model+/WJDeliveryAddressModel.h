//
//  WJDeliveryAddressModel.h
//  HuPlus
//
//  Created by reborn on 16/12/27.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJDeliveryAddressModel : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *detailAddress;

@property(nonatomic,assign)BOOL     isDefaultAddress;
@property(nonatomic,strong)NSString *provinceId;
@property(nonatomic,strong)NSString *cityId;
@property(nonatomic,strong)NSString *districtId;

@property(nonatomic,strong)NSString *provinceName;
@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,strong)NSString *districtName;

@property(nonatomic,strong)NSString *receivingId;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
