//
//  AppDelegate.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/14.
//  Copyright © 2016年 XT Xiong. All rights reserved.
//

#import "AppDelegate.h"
#import "WJSqliteBaseManager.h"
#import "WJBuglyManager.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import "UMMobClick/MobClick.h"
#import "WJShareManager.h"
#import "WJPushManager.h"
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    BMKMapManager * mapManager;
    
    BOOL isFirstLoadAfterInstalled;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    isFirstLoadAfterInstalled = [WJUtilityMethod whetherIsFirstLoadAfterInstalled];

    [self initBaiduMap];
    [self initBugly];
    [self initUMeng];
    [self initDatabase];
    [self initWJShare];
    [self initPushNotification:launchOptions];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.tabBarController = [[WJTabBarController alloc]init];
    self.window.rootViewController = _tabBarController;
    [self.window makeKeyAndVisible];
    
//    [NSThread sleepForTimeInterval:1];

    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"程序即将进入后台");
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0) {

        [WJPushManager setBadge:0];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"程序即将进入前台");
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0) {
        
        [WJPushManager setBadge:0];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0) {
        
        [WJPushManager setBadge:0];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
}


#pragma mark - JPush
- (void)initPushNotification:(NSDictionary *)launchOptions{
    [WJPushManager instancePushManager:launchOptions];
}

//请求完毕后会调用此方法，返回deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken:%@",deviceToken);
    [WJPushManager registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"接受到通知");
    [JPUSHService handleRemoteNotification:userInfo];
    
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateInactive) {
        //进入结果页
        [self pushControllerByPushNotification:userInfo withType:3-application.applicationState];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
//    NSLog(@"接受到通知");
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateInactive) {
        //进入结果页
        [self pushControllerByPushNotification:userInfo withType:3-application.applicationState];
    }
}

- (void)handleLaunchWithapplication:(UIApplication*)application RemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"push user id =================%@",userInfo);
    //badge置0
    [WJPushManager setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
//    // 取得 APNs 标准信息内容
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    
    //applicationState有3个状态, UIApplicationStateActive(在前端运行),UIApplicationStateInactive(从后台进入前端),UIApplicationStateBackground在后台端运行
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateInactive) {
        //进入结果页
        [self pushControllerByPushNotification:userInfo withType:3-application.applicationState];
    }
}

- (void)pushControllerByPushNotification:(NSDictionary *)pushNotificationUserInfo withType:(NSInteger)category{
    
    NSInteger type = [pushNotificationUserInfo[@"type"] intValue];
    
    [[NSUserDefaults standardUserDefaults] setObject:@{@"pushType":@(type), @"pushCategory":@(category), @"PushUserInfo":pushNotificationUserInfo} forKey:@"PushArguments"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tabBarController receiveNotification];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self handleLaunchWithapplication:[UIApplication sharedApplication] RemoteNotification:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];

    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self handleLaunchWithapplication:[UIApplication sharedApplication] RemoteNotification:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];

    }
    completionHandler();  // 系统要求执行这个方法
}



#pragma mark - Handle Url

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //分享回调
    [WJShareManager shareHandleOpenURL:url sourceApplication:sourceApplication];

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options
{
    //分享回调
    [WJShareManager application:app openURL:url options:options];

    return YES;
}

#pragma mark - 初始化SDK
- (void)initWJShare
{
    //分享和支付共用
    [WJShareManager initShareEnviroment];
}

//百度地图
- (void)initBaiduMap
{
    mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:BaiduMap_AppKey generalDelegate:nil];
    
    if (!ret) {
        NSLog(@"BaiduMap manager start failed!");
    }
}

//Bugly
- (void)initBugly
{
    [[WJBuglyManager sharedCrashManager] installWithAppId:Bugly_AppKey];
}                                                           

//UMeng
- (void)initUMeng
{
    UMConfigInstance.appKey = UMeng_AppKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
}

//所在地选择 地区表
- (void)initDatabase
{
    if(isFirstLoadAfterInstalled){
        [WJSqliteBaseManager copyBaseData];
    }
}

@end
