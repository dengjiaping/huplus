//
//  WJChargeValueModel.m
//  HuPlus
//
//  Created by reborn on 16/12/30.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJChargeValueModel.h"

@implementation WJChargeValueModel
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if(self == [super init])
    {
        self.sellValue = [NSString stringWithFormat:@"%.2f",[ToString(dic[@"sellPrice"]) floatValue]];
        self.cardID = ToString(dic[@"id"]);
        self.faceValue = ToString(dic[@"faceValue"]);
    }
    return self;
}
@end
