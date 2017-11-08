//
//  APIGetSizeColorSkuidManager.h
//  HuPlus
//
//  Created by reborn on 17/2/17.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIGetSizeColorSkuidManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *sizeId;
@property (nonatomic, strong) NSString *colorId;
@end
