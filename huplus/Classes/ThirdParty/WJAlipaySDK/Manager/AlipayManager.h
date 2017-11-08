//
//  AlipayManager.h
//  HuPlus
//
//  Created by XT Xiong on 2017/3/20.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>

@interface AlipayManager : NSObject

@property (nonatomic, strong) WJViewController  * selectPaymentVC;
@property (nonatomic, strong) NSString          * totleCash;

+ (instancetype)alipayManager;

- (void)callAlipayWithOrderString:(NSString *)orderString;

- (void)handleOpenURL:(NSURL *)url;

@end
