//
//  APIBrandDetailManager.h
//  HuPlus
//
//  Created by reborn on 17/2/25.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIBrandDetailManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property(nonatomic,strong)NSString *brandId;
@end
