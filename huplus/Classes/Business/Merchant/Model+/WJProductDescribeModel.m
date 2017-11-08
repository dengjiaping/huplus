//
//  WJProductDescribeModel.m
//  HuPlus
//
//  Created by reborn on 17/2/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJProductDescribeModel.h"

@implementation WJProductDescribeModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.name       = ToString(dic[@"extend_name"]);
        self.content    = ToString(dic[@"extend_value"]);
        
    }
    return self;
}
@end
