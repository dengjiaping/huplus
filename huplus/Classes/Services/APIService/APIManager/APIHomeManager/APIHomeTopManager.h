//
//  APIHomeTopManager.h
//  HuPlus
//
//  Created by reborn on 17/2/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIHomeTopManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property(nonatomic ,strong)NSString  *idfaString;
@property(nonatomic ,strong)NSString  *udidString;


@end
