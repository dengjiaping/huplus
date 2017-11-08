//
//  WJHotKeysModel.m
//  HuPlus
//
//  Created by reborn on 16/12/21.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJHotKeysModel.h"

@implementation WJHotKeysModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.hotKeyId = ToString(dic[@"id"]);
        self.name = ToString(dic[@"hot_words"]);
    }
    return self;
}

@end
