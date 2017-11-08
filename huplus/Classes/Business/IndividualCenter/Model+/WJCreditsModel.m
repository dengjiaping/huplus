//
//  WJCreditsModel.m
//  HuPlus
//
//  Created by reborn on 16/12/23.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJCreditsModel.h"

@implementation WJCreditsModel
- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.creditsNum = ToString(dic[@"creditsNum"]);
        self.creditsDes = ToString(dic[@"creditsDes"]);
        self.createTime = ToString(dic[@"createTime"]);
        self.TimeDes = ToString(dic[@"TimeDes"]);
   
    }
    return self;
}



@end
