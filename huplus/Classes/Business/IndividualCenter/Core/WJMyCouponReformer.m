//
//  WJMyCouponReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJMyCouponReformer.h"
#import "WJCouponListModel.h"
@implementation WJMyCouponReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    WJCouponListModel *couponListModel = [[WJCouponListModel alloc] initWithDic:data];
    
    return couponListModel;
}


@end
