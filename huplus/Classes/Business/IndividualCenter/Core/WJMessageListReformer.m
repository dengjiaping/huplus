//
//  WJMessageListReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/27.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJMessageListReformer.h"
#import "WJMessageListModel.h"
@implementation WJMessageListReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJMessageListModel *messageListModel = [[WJMessageListModel alloc] initWithDic:data];
    return messageListModel;
}

@end
