//
//  WJRefundProgressReformer.m
//  HuPlus
//
//  Created by reborn on 17/3/29.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJRefundProgressReformer.h"
#import "WJRefundProgressModel.h"
@implementation WJRefundProgressReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data[@"order_path_list"] isKindOfClass:[NSArray class]]) {
        
        for (id obj in data[@"order_path_list"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                WJRefundProgressModel *refundProgressModel = [[WJRefundProgressModel alloc] initWithDictionary:obj];
                [result addObject:refundProgressModel];
                
            }
        }
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:data];
    
    [dataDic setValue:result forKey:@"order_path_list"];
    [dataDic setValue:data[@"status"] forKey:@"status"];

    
    return dataDic;
    
}
@end
