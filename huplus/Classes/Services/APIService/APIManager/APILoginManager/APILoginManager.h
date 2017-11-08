//
//  APILoginManager.h
//  HuPlus
//
//  Created by XT Xiong on 2017/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APILoginManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString * phoneNum;
@property (nonatomic, strong) NSString * verificationCode;
@property (nonatomic, strong) NSString * terminal;             //终端类型(0：ios、1：android）
@property (nonatomic, strong) NSString * JPushID;              //极光ID



@end
