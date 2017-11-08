//
//  WJMessageListModel.m
//  HuPlus
//
//  Created by reborn on 17/2/27.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJMessageListModel.h"
#import "WJSystemNewsModel.h"
@implementation WJMessageListModel
- (id)initWithDic:(NSDictionary *)dic
{
    self.totalPage   = [dic[@"total_page"] integerValue];

    NSMutableArray * resultsArray  = [NSMutableArray array];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSDictionary * result = [NSDictionary dictionary];
        result = [dic objectForKey:@"message_list"];
        for (id obj in result) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                WJSystemNewsModel *systemNewsModel = [[WJSystemNewsModel alloc] initWithDictionary:obj];
                [resultsArray addObject:systemNewsModel];
            }
        }
        self.messageListArray = [NSMutableArray arrayWithArray:resultsArray];
        
    }
    return self;
}
@end
