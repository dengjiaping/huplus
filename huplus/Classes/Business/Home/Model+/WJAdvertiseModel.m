//
//  WJAdvertiseModel.m
//  HuPlus
//
//  Created by reborn on 17/3/7.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJAdvertiseModel.h"

@implementation WJAdvertiseModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.picUrl          = ToString(dic[@"pic_url"]);
        self.linkType        = ToString(dic[@"link_type"]);
        self.linkUrl         = ToString(dic[@"link_url"]);
        self.positonNumber   = [dic[@"adposition_no"] integerValue];
        self.des             = ToString(dic[@"descriptions"]);
    }
    return self;
}
@end
