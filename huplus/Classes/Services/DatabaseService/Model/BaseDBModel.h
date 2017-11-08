//
//  BaseDBModel.h
//  HuPlus
//
//  Created by reborn on 16/12/28.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface BaseDBModel : NSObject

-(id)initWithDic:(NSDictionary*)dic;

- (id)initWithCursor:(FMResultSet *)cursor;
@end
