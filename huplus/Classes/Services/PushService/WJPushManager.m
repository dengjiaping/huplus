//
//  WJPushManager.m
//  HuPlus
//
//  Created by XT Xiong on 2017/2/20.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJPushManager.h"
#import <UserNotifications/UserNotifications.h>

@implementation WJPushManager

+ (void)instancePushManager:(NSDictionary *)launchOptions
{
    
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert
        | UNAuthorizationOptionBadge
        | UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:nil];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                UIRemoteNotificationTypeSound |
                                                UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPush_AppKey
                          channel:@"App Store"
                 apsForProduction:NO];
}

+ (void)registerDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    [WJPushManager setPushToken:deviceToken];
}

+ (void)setPushToken:(NSData *)pushToken{
    
    NSString *deviceTokenStr = [[pushToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceTokenStr==%@",deviceTokenStr);
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:@"currentPushToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo
{
    [JPUSHService handleRemoteNotification:remoteInfo];
}

#pragma mark - Push setting

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler{
    
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
}


+ (void)setTags:(NSSet *)tags
          alias:(NSString *)alias
callbackSelector:(SEL)cbSelector
         object:(id)theTarget
{
    [JPUSHService setTags:tags alias:alias callbackSelector:cbSelector object:theTarget];
}

+ (void)setTags:(NSSet *)tags
callbackSelector:(SEL)cbSelector
         object:(id)theTarget
{
    [JPUSHService setTags:tags callbackSelector:cbSelector object:theTarget];
}

+ (void)setAlias:(NSString *)alias
callbackSelector:(SEL)cbSelector
          object:(id)theTarget
{
    [JPUSHService setAlias:alias callbackSelector:cbSelector object:theTarget];
}

+ (NSSet *)filterValidTags:(NSSet *)tags
{
    return [JPUSHService filterValidTags:tags];
}


+ (BOOL)setBadge:(NSInteger)value
{
    return [JPUSHService setBadge:value];
}

+ (void)resetBadge
{
    [JPUSHService resetBadge];
}

+ (NSString *)registrationID
{
    return [JPUSHService registrationID];
}

+ (void)setDebugMode
{
    [JPUSHService setDebugMode];
}

+ (void)setLogOFF
{
    [JPUSHService setLogOFF];
}

@end
