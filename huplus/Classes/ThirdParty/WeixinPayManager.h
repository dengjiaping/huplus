//
//  WeixinPayManager.h
//  HuPlus
//
//  Created by XT Xiong on 2017/3/19.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WeixinPayManager : NSObject<WXApiDelegate>

+ (instancetype)WXPayManager;

@property (nonatomic, strong) WJViewController  * selectPaymentVC;
@property (nonatomic, strong) NSString          * totleCash;


- (void)callWexinPayWithPrePayid:(NSString *)prePayid;

@end
