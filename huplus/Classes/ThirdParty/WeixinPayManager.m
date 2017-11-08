//
//  WeixinPayManager.m
//  HuPlus
//
//  Created by XT Xiong on 2017/3/19.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WeixinPayManager.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "WJSystemAlertView.h"
#import "SecurityService.h"
#import "WJPayResultViewController.h"

@implementation WeixinPayManager

+ (instancetype)WXPayManager
{
    static dispatch_once_t onceToken;
    static WeixinPayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WeixinPayManager alloc]init];
    });
    return instance;
}

#pragma mark - Request WeiXin 
//拿到prePayId创建请求参数
- (void)callWexinPayWithPrePayid:(NSString *)prePayid
{
    NSString    *package, *time_stamp, *nonce_str;
    //设置支付参数
    time_t now;
    time(&now);
    time_stamp  = [NSString stringWithFormat:@"%ld", now];
    nonce_str	= [SecurityService md5ForString:time_stamp];

    package         = @"Sign=WXPay";
    //第二次签名参数列表
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: WX_AppID        forKey:@"appid"];
    [signParams setObject: nonce_str    forKey:@"noncestr"];
    [signParams setObject: package      forKey:@"package"];
    [signParams setObject: WX_MchID        forKey:@"partnerid"];
    [signParams setObject: time_stamp   forKey:@"timestamp"];
    [signParams setObject: prePayid     forKey:@"prepayid"];
    //[signParams setObject: @"MD5"       forKey:@"signType"];
    //生成签名
    NSString *sign  = [self createMd5Sign:signParams];
    
    //添加签名
    [signParams setObject: sign         forKey:@"sign"];
    [self sendWXPayWith:signParams];
}

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", WX_PartnerID];
    //得到MD5 sign签名
    NSString *md5Sign = [SecurityService md5ForString:contentString];
    
    return md5Sign;
}

//向微信发出请求
- (void)sendWXPayWith:(NSDictionary *)dic
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if(dict != nil){
        NSMutableString *retcode = [dict objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        }else{
            //            [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
        }
    }else{
        //        [self alert:@"提示信息" msg:@"服务器返回错误，未获取到json对象"];
    }
}

#pragma mark - WeiXin Response

// 微信支付成功或者失败回调
- (void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        if (resp.errCode == WXSuccess) {
            WJPayResultViewController *successViewController = [[WJPayResultViewController alloc] init];
            successViewController.totleCash = self.totleCash;
            [self.selectPaymentVC.navigationController pushViewController:successViewController animated:YES whetherJump:YES];
        }else{
            ALERT(@"支付失败！");
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
        }
    }
}


@end
