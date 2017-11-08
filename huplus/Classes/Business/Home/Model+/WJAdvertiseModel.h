//
//  WJAdvertiseModel.h
//  HuPlus
//
//  Created by reborn on 17/3/7.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJAdvertiseModel : NSObject
@property(nonatomic, strong)NSString *picUrl;
@property(nonatomic, strong)NSString *linkUrl;
@property(nonatomic, strong)NSString *des;
@property(nonatomic, strong)NSString *linkType;
@property(nonatomic, assign)NSInteger positonNumber;


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
