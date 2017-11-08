//
//  WJThirdShopListModel.h
//  HuPlus
//
//  Created by reborn on 17/2/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJThirdShopListModel : NSObject
@property(nonatomic, strong)NSString *imgUrl;
@property(nonatomic, strong)NSString *shopIconUrl;
@property(nonatomic, strong)NSString *shopName;
@property(nonatomic, strong)NSString *shopId;
@property(nonatomic, assign)NSInteger saleCount;
@property(nonatomic, strong)NSString *shopDetailUrl;
@property(nonatomic ,assign)NSInteger storeType; //1:旗舰店2：专卖店3：经营店4:个人店

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
