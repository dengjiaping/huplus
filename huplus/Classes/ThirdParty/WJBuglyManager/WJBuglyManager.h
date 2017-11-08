//
//  WJBuglyManager.h
//  HuPlus
//
//  Created by XT Xiong on 2016/12/19.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJBuglyManager : NSObject

@property (nonatomic, copy) void (^buglyBlock)(void);

+ (instancetype)sharedCrashManager;

/**
 *    @brief  初始化SDK接口并启动崩溃捕获上报功能
 *
 *    @param appId 应用标识, 在平台注册时分配的应用标识
 *
 */
- (void)installWithAppId:(NSString *)appId;

- (void)changeUserId;

@end
