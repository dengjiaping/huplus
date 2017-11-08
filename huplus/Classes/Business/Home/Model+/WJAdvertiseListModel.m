//
//  WJAdvertiseListModel.m
//  HuPlus
//
//  Created by reborn on 17/3/22.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJAdvertiseListModel.h"
#import "WJAdvertiseModel.h"
@implementation WJAdvertiseListModel
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.advertiseType = ToString(dic[@"template_id"]);
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *productDic in dic[@"pic_list"]) {
            WJAdvertiseModel *advertiseModel = [[WJAdvertiseModel alloc] initWithDictionary:productDic];
            [arr addObject:advertiseModel];
        }
        self.picListArray = [NSMutableArray arrayWithArray:arr];
        [arr removeAllObjects];
        
    }
    return self;
}
@end
