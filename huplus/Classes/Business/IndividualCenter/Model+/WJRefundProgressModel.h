//
//  WJRefundProgressModel.h
//  HuPlus
//
//  Created by reborn on 17/3/24.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJRefundProgressModel : NSObject

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *content;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
