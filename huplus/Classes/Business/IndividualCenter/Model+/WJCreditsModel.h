//
//  WJCreditsModel.h
//  HuPlus
//
//  Created by reborn on 16/12/23.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCreditsModel : NSObject

@property(nonatomic,strong)NSString *creditsNum;
@property(nonatomic,strong)NSString *creditsDes;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *TimeDes;

- (id)initWithDic:(NSDictionary *)dic;

@end
