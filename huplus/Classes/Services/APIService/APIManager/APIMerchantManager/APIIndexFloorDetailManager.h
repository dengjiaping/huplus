//
//  APIIndexFloorDetailManager.h
//  HuPlus
//
//  Created by XT Xiong on 2017/2/18.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIIndexFloorDetailManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString * floorId;

@end
