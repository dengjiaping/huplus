//
//  APICommonParamsGenerator.m
//  LESports
//
//  Created by ZhangQibin on 15/6/22.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import "APICommonParamsGenerator.h"
#import <UIKit/UIKit.h>


@implementation APICommonParamsGenerator

+ (NSDictionary *)commonParamsDictionary
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{}];
    
    //时间挫
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString *currentTimeString = [formatter stringFromDate:[NSDate date]];
    
    parameters[@"sign_type"] = @"MD5";
    parameters[@"channel"] = KChannel;
    parameters[@"timestamp"] = currentTimeString;
    parameters[@"system_id"] = @"12";
    parameters[@"version"] = kSystemVersion;
    parameters[@"terminal"] = @"11";
    return parameters;
}



+ (NSDictionary *)cashTransferCommonParamsDictionary
{
    UIDevice *currentDevice = [UIDevice currentDevice];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{}];
    
//    WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
    
//    NSDictionary  *cashUser = [[NSUserDefaults standardUserDefaults] dictionaryForKey:KCashUser];
//    NSString * token = [cashUser objectForKey:@"token"];
    
//    if (nil != cashUser && nil != token && 0 != token.length) {
//        [parameters addEntriesFromDictionary:@{@"token":token}];
//    }else{
//        
//        NSString *newToken = [[NSUserDefaults standardUserDefaults] objectForKey:kTokenForChangePhone][@"token"];
//        if (newToken) {
//            
//            [parameters addEntriesFromDictionary:@{@"token":newToken}];
//            
//        }else{
//            
//            [parameters addEntriesFromDictionary:@{@"token":@""}];
//        }
//    }
    
    parameters[@"appType"] = kAppJAVAID;
    parameters[@"buildModel"] = [NSString stringWithFormat:@"%@", currentDevice.model];
    parameters[@"deviceId"] = [[WJUtilityMethod keyChainValue:NO] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    parameters[@"deviceVersion"] = currentDevice.systemVersion;
    parameters[@"appVersion"] = WJCardAppVersion;
    
    //    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    parameters[@"appVersion"] = infoDictionary[@"CFBundleShortVersionString"];
    //    parameters[@"app_build_version"] = infoDictionary[(__bridge_transfer NSString *) kCFBundleVersionKey];
    
    return parameters;
}



@end
