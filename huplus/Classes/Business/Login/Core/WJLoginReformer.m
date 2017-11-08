//
//  WJLoginReformer.m
//  HuPlus
//
//  Created by XT Xiong on 2017/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJLoginReformer.h"

@implementation WJLoginReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:data];
    [userDic removeObjectsForKeys:@[@"cert_code",@"terminal",@"email",@"status"]];
    //防止出现null
    NSArray *keysArray = [userDic allKeys];
    for (int i = 0; i < keysArray.count; i++) {
        NSString * valueStr = [userDic valueForKey:keysArray[i]];
        if ([valueStr isEqual:[NSNull null]]) {
            [userDic setValue:@"" forKey:keysArray[i]];
        }
    }
    return userDic;
}
@end
