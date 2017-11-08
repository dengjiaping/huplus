//
//  WJIndividualCenterReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJIndividualCenterReformer.h"
#import "WJIndividualCenterModel.h"
@implementation WJIndividualCenterReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJIndividualCenterModel *individualCenterModel = [[WJIndividualCenterModel alloc] initWithDic:data];

    return individualCenterModel;
}

@end
