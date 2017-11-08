//
//  WJAttributeModel.h
//  HuPlus
//
//  Created by reborn on 17/2/16.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJAttributeModel : NSObject

@property(nonatomic,strong)NSString *attributeName;
@property(nonatomic,strong)NSMutableArray *listArray;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
