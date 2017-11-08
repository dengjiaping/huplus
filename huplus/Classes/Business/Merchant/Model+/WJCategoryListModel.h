//
//  WJCategoryListModel.h
//  HuPlus
//
//  Created by XT Xiong on 2017/2/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCategoryListModel : NSObject

@property(nonatomic,strong)NSString         *categoryId;
@property(nonatomic,strong)NSString         *categoryName;
@property(nonatomic,strong)NSString         *categoryPic;
@property(nonatomic,strong)NSMutableArray   *childListArray;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end
