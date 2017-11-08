//
//  BaseDBManager.m
//  HuPlus
//
//  Created by reborn on 16/12/28.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "BaseDBManager.h"
#import "SqliteManager.h"

@implementation BaseDBManager

- (FMResultSet *)queryInTable:(NSString *)table
             withWhereClauses:(NSString *)whereClause
           withWhereArguments:(NSArray *)whereArgumentsInArray
                  withOrderBy:(NSString *) order
                withOrderType:(TS_ORDER_E) orderType
{
    if (nil == whereClause || NO == IS_VALID_ORDER(orderType)) {
        NSLog(@"parameter is invalid");
        return nil;
    }
    
    return [self.sqliteManager query:table
                  withColumnsInArray:nil
                    withWhereClauses:whereClause
           withWhereArgumentsInArray:whereArgumentsInArray
                         withOrderBy:order
                        withOderType:orderType];
}

- (FMResultSet *)queryAllInTable:(NSString *)table
{
    return [self.sqliteManager query:table
                  withColumnsInArray:nil
                    withWhereClauses:nil
           withWhereArgumentsInArray:nil
                         withOrderBy:nil
                        withOderType:ORDER_BY_NONE];
}


- (FMResultSet*)querySql:(NSString*)sql{
    return [self.sqliteManager querySql:sql];
}

@end
