//
//  WJHomeBannerModel.h
//  HuPlus
//
//  Created by reborn on 17/2/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJHomeBannerModel : NSObject<NSCoding>

@property(nonatomic, strong)NSString *linkType;
@property(nonatomic, strong)NSString *linkUrl;
@property(nonatomic, strong)NSString *picUrl;
@property(nonatomic, strong)NSString *title;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
