//
//  WJSqliteBaseManager.h
//  HuPlus
//
//  Created by reborn on 16/12/28.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "SqliteManager.h"

@interface WJSqliteBaseManager : SqliteManager

+ (instancetype)sharedManager;

+ (void)copyBaseData;

@end