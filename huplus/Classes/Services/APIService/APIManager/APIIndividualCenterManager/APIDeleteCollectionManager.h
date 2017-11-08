//
//  APIDeleteCollectionManager.h
//  HuPlus
//
//  Created by reborn on 17/2/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIDeleteCollectionManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * productId;

@end
