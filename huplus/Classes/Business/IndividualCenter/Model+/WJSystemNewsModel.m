//
//  WJSystemNewsModel.m
//  HuPlus
//
//  Created by reborn on 17/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJSystemNewsModel.h"

@implementation WJSystemNewsModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.title               = ToString(dic[@"message_title"]);
        self.content             = ToString(dic[@"message_content"]);
        self.goodsName               = ToString(dic[@"goods_name"]);
        self.date                = ToString(dic[@"update_date"]);
        self.assetData                = ToString(dic[@"message_time"]);
        self.messageContent                = ToString(dic[@"content"]);
        self.orderNo             = ToString(dic[@"order_id"]);
        self.productImgUrl       = ToString(dic[@"head_pic"]);
        self.messageId           = ToString(dic[@"message_id"]);
        self.messageType         = [dic[@"mess_type"] integerValue];

    }
    return self;
}


@end
