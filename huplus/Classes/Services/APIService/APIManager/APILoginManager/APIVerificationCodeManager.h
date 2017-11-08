//
//  APIVerificationCodeManager.h
//  HuPlus
//
//  Created by XT Xiong on 2017/2/9.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIVerificationCodeManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString * phoneNum;

@end
