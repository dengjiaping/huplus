//
//  WJOrderListModel.h
//  HuPlus
//
//  Created by reborn on 17/2/27.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJOrderListModel : NSObject
@property(nonatomic,assign)NSInteger      totalPage;
@property(nonatomic,strong)NSMutableArray *orderList;
- (id)initWithDic:(NSDictionary *)dic;

@end
