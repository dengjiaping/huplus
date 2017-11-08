//
//  WJMyCollectionModel.h
//  HuPlus
//
//  Created by reborn on 17/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJMyCollectionModel : NSObject

@property (nonatomic, strong) NSMutableArray  *collectionListArray;
@property (nonatomic, assign) NSInteger       totalCount;

- (id)initWithDic:(NSDictionary *)dic;


@end
