//
//  WJMessageListModel.h
//  HuPlus
//
//  Created by reborn on 17/2/27.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJMessageListModel : NSObject
@property (nonatomic, strong) NSMutableArray  *messageListArray;
@property (nonatomic, assign) NSInteger       totalPage;

- (id)initWithDic:(NSDictionary *)dic;

@end
