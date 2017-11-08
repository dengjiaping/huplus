//
//  WJDBAreaManager.m
//  HuPlus
//
//  Created by reborn on 16/12/28.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJDBAreaManager.h"
#import "WJSqliteBaseManager.h"

@implementation WJDBAreaManager

- (instancetype)init{
    if (self = [super init]) {
        self.sqliteManager = [WJSqliteBaseManager sharedManager];
    }
    return self;
}

#pragma mark - 具体接口

-(NSMutableArray *)getSubAreaByParentId:(NSString *)parentId
{
    
    NSMutableArray *areaList = [[NSMutableArray alloc]init];
    
    FMResultSet *cursor = [self queryInTable:TABLE_AREA
                            withWhereClauses:@"AREA_PARENTNO = ?"
                          withWhereArguments:@[parentId]
                                 withOrderBy:COL_AREA_ID
                               withOrderType:ORDER_BY_ASC];
    
    while ([cursor next]) {
        WJAreaModel *area = [[WJAreaModel alloc] initWithCursor:cursor];
        [areaList addObject:area];
    }
    [cursor close];
    
    return areaList;
}

-(NSMutableArray *)getAllAreasByLevel:(NSInteger)level
{
    NSMutableArray *areaList = [[NSMutableArray alloc]init];
    
    FMResultSet *cursor = [self queryInTable:TABLE_AREA
                            withWhereClauses:@"AREA_RANK = ?"
                          withWhereArguments:@[@(level)]
                                 withOrderBy:COL_AREA_ID
                               withOrderType:ORDER_BY_ASC];
    
    while ([cursor next]) {
        WJAreaModel *area = [[WJAreaModel alloc] initWithCursor:cursor];
        [areaList addObject:area];
    }
    [cursor close];
    
    return areaList;
    
}

@end
