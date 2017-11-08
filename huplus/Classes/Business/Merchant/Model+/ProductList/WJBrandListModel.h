//
//  WJBrandListModel.h
//  HuPlus
//
//  Created by XT Xiong on 2017/2/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJBrandListModel : NSObject

@property(nonatomic,strong)NSString         *brandId;
@property(nonatomic,strong)NSString         *brandName;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end
