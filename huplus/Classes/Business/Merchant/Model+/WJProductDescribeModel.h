//
//  WJProductDescribeModel.h
//  HuPlus
//
//  Created by reborn on 17/2/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJProductDescribeModel : NSObject

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *content;

- (instancetype)initWithDictionary:(NSDictionary *)dic;


@end
