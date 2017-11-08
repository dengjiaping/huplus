//
//  WJBuglyManager.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/19.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJBuglyManager.h"
#import <Bugly/Bugly.h>

@interface WJBuglyManager()<BuglyDelegate>


@end

@implementation WJBuglyManager

static WJBuglyManager * instance;
+ (instancetype)sharedCrashManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WJBuglyManager alloc] init];
    });
    return instance;
}

- (void)installWithAppId:(NSString *)appId{
    [self setConfigWithAppId:appId];
}


- (void)setConfigWithAppId:(NSString *)appid{
    //接入第三方
    
    NSString *buildNO = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    
    BuglyConfig *config = [BuglyConfig new];
    
    config.channel = @"AppStore";
    config.version = [NSString stringWithFormat:@"%@-%@", WJCardAppVersion,buildNO];
    config.deviceIdentifier = [WJGlobalVariable sharedInstance].currentID;
    config.unexpectedTerminatingDetectionEnable = YES;
    config.delegate = self;
    
    [Bugly startWithAppId:appid config:config];
    
    [BuglyLog initLogger:BuglyLogLevelWarn consolePrint:NO];
    
    [self changeUserId];
    
}

- (void)changeUserId{
    
//    NSString *strUUID = [WJGlobalVariable sharedInstance].currentID;
//    
//    NSString *userID = nil;
//    if ([WJGlobalVariable sharedInstance].defaultPerson.userName) {
//        
//        userID = [strUUID stringByAppendingString:[WJGlobalVariable sharedInstance].defaultPerson.userName];
//    }else{
//        
//        userID = strUUID;
//    }
//    NSLog(@"bugly userid ==== %@",userID);
    
    //    [Bugly setUserIdentifier:userID];
}


- (NSString *)attachmentForException:(NSException *)exception{
    return @"exception";
}


@end
