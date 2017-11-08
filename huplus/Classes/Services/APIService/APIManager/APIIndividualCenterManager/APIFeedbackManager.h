//
//  APIFeedbackManager.h
//  HuPlus
//
//  Created by XT Xiong on 2017/2/17.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIFeedbackManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString      * userId;
@property (nonatomic, assign) NSString      * contentStr;

@end
