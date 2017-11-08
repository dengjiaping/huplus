//
//  WJChargeValueModel.h
//  HuPlus
//
//  Created by reborn on 16/12/30.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJChargeValueModel : NSObject
@property (nonatomic, strong) NSString * sellValue;
@property (nonatomic, strong) NSString * cardID;
@property (nonatomic, strong) NSString * faceValue;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
