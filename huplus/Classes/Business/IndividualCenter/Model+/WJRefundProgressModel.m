//
//  WJRefundProgressModel.m
//  HuPlus
//
//  Created by reborn on 17/3/24.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJRefundProgressModel.h"

@implementation WJRefundProgressModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.title             = ToString(dic[@"title"]);
        self.name             = ToString(dic[@"name"]);
        self.time             = ToString(dic[@"refund_time"]);
        self.content             = ToString(dic[@"content"]);
    }
    return self;
}
@end
