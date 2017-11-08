//
//  WJDBAreaManager.h
//  HuPlus
//
//  Created by reborn on 16/12/28.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "BaseDBManager.h"
#import "BaseDBManager.h"
//#import "WJModelArea.h"
#import "WJAreaModel.h"

@interface WJDBAreaManager : BaseDBManager

-(NSMutableArray *)getSubAreaByParentId:(NSString *)parentId;

-(NSMutableArray *)getAllAreasByLevel:(NSInteger)level;//省1 城市2


@end
