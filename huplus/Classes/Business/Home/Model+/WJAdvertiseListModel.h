//
//  WJAdvertiseListModel.h
//  HuPlus
//
//  Created by reborn on 17/3/22.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJAdvertiseListModel : NSObject

@property(nonatomic,strong)NSString       *advertiseType;
@property(nonatomic,strong)NSMutableArray *picListArray;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
