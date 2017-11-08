//
//  WJThirdShopModel.h
//  HuPlus
//
//  Created by reborn on 17/2/23.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJThirdShopModel : NSObject
@property(nonatomic, strong)NSMutableArray *shopListArray;
@property(nonatomic, assign)NSInteger      totalPage;

- (id)initWithDic:(NSDictionary *)dic;

@end
