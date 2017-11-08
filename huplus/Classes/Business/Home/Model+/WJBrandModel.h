//
//  WJBrandModel.h
//  HuPlus
//
//  Created by reborn on 17/1/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJBrandModel : NSObject

@property (nonatomic, strong)NSString   *imageUrl;
@property (nonatomic, strong)NSString   *brandName;
@property (nonatomic, strong)NSString   *brandID;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
