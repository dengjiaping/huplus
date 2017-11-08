//
//  WJJudgementDefine.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#ifndef WanJiCard_WJJudgementDefine_h
#define WanJiCard_WJJudgementDefine_h



#define TestAPI     0

#define AppVersion  @"1.0.2"

#define KChannel    @"App Store"


#define kAppID          @"10002"
#define kAppIDKey       @"app_id"
#define kAppJAVAID      @"1_2"

//JAVA Version
#define kSystemVersion      @"1.8"



#define WJCardAppVersion  [WJUtilityMethod versionNumber]


#define deviceIs6P      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6OrThan        (kScreenWidth>320.f)

#define USER_ID   [[NSUserDefaults standardUserDefaults] dictionaryForKey:KUserInformation][@"user_id"]
#define USER_TEL  [[NSUserDefaults standardUserDefaults] dictionaryForKey:KUserInformation][@"login_name"]
#define USER_headPortrait  [[NSUserDefaults standardUserDefaults] dictionaryForKey:KUserInformation][@"head_portrait"]

#define BitmapBrandImage  [UIImage imageNamed:@"bitmap_brand"]
#define BitmapCommodityImage  [UIImage imageNamed:@"bitmap_commodity"]
#define BitmapBannerImage  [UIImage imageNamed:@"bitmap_banner"]
#define BitmapCustomImage  [UIImage imageNamed:@"bitmap_custom"]
#define BitmapHeaderImg    [UIImage imageNamed:@"headerImg"]

#define ISOFFICIAL [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] isEqualToString:@"com.ihujia.vplus"]

#define SystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS8_LATER SystemVersionGreaterOrEqualThan(8.0)


#define perfix ((int)[UIScreen mainScreen].scale == 1 ? @"":((int)[UIScreen mainScreen].scale == 2?@"@2x":@"@3x"))
#define resourceImagePath(imageString) [UIImage imageNamed:imageString]
// [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@", imageString, perfix] ofType:@"png"]]

#endif
