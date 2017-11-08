//
//  WJDeliveryAddressListModel.h
//  HuPlus
//
//  Created by reborn on 17/2/22.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJDeliveryAddressListModel : NSObject
@property(nonatomic,strong)NSMutableArray *addresslistArray;
@property(nonatomic,assign)NSInteger      totalPage;

- (id)initWithDic:(NSDictionary *)dic;


@end
