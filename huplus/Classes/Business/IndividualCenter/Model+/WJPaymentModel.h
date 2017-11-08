//
//  WJPaymentModel.h
//  HuPlus
//
//  Created by reborn on 17/2/23.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJPaymentModel : NSObject
@property(nonatomic,strong)NSString  *accountBalance;
@property(nonatomic,strong)NSString  *orderId;
@property(nonatomic,strong)NSString  *orderName;
@property(nonatomic,strong)NSString  *orderTotal;
@property(nonatomic,strong)NSString  *payMentType; // 失效的支付方式 1：支付宝、2：微信、3：卡号

- (id)initWithDic:(NSDictionary *)dic;

@end
