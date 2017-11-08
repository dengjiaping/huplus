//
//  APIModifyInformationManager.h
//  HuPlus
//
//  Created by reborn on 17/2/24.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIModifyInformationManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *headPic;
@property(nonatomic, strong)NSString *userName;
@property(nonatomic, strong)NSString *sex; // 0男 1女
@property(nonatomic, strong)NSString *birthday;
@property(nonatomic, strong)NSString *provinceId;
@property(nonatomic, strong)NSString *cityId;
@property(nonatomic, strong)NSString *districtId;










@end
