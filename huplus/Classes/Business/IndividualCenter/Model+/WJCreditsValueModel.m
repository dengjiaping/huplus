//
//  WJCreditsValueModel.m
//  HuPlus
//
//  Created by reborn on 16/12/23.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJCreditsValueModel.h"

@implementation WJCreditsValueModel
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if(self == [super init])
    {
        self.sellValue = [NSString stringWithFormat:@"%.2f",[ToString(dic[@"sellPrice"]) floatValue]];
        self.cardID = ToString(dic[@"id"]);
        self.faceValue = ToString(dic[@"thirdCardFacePrice"]);
    }
    return self;
}
@end
