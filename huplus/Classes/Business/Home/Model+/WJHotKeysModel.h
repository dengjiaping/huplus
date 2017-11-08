//
//  WJHotKeysModel.h
//  HuPlus
//
//  Created by reborn on 16/12/21.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJHotKeysModel : NSObject
@property (nonatomic, strong)NSString   *hotKeyId;
@property (nonatomic, strong)NSString   *name;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
