//
//  AlipayManager.m
//  HuPlus
//
//  Created by XT Xiong on 2017/3/20.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "AlipayManager.h"
#import "WJPayResultViewController.h"

@implementation AlipayManager

+ (instancetype)alipayManager
{
    static dispatch_once_t onceToken;
    static AlipayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AlipayManager alloc]init];
    });
    return instance;
}

- (void)callAlipayWithOrderString:(NSString *)orderString
{
        NSString *appScheme = @"hujia";
        //调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
        }];
}

- (void)handleOpenURL:(NSURL *)url
{
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            WJPayResultViewController *successViewController = [[WJPayResultViewController alloc] init];
            successViewController.totleCash = self.totleCash;
            [self.selectPaymentVC.navigationController pushViewController:successViewController animated:YES whetherJump:YES];
        }else{
            ALERT(@"支付失败！");
        }
    }];
}


@end
