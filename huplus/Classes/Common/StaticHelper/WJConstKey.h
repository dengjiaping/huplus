//
//  WJConstKey.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#ifndef WanJiCard_WJConstKey_h
#define WanJiCard_WJConstKey_h




#define kScreenWidth                [UIScreen mainScreen].bounds.size.width
#define kScreenHeight               [UIScreen mainScreen].bounds.size.height
#define kTabbarHeight               49.0f
#define kStatusBarHeight            20.0f
#define kNavigationBarHeight        44.0f
#define kNavBarAndStatBarHeight     64.0f
#define kAllBarHeight               113.0f

#define kDefaultCenter              [NSNotificationCenter defaultCenter]

#define ALD(x)      (x * kScreenWidth/375.0)
#define TopDem(x)   ([UIScreen mainScreen].scale >= 3 ? x*1.5 : x)


#define AppGroups                  [NSString stringWithFormat:@"group.%@", [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"]]   //  group id
#define AppVersioin         @"CFBundleShortVersionString"
#define AppBuildNumber      @"CFBundleVersion"


//NSUserDefaults 关键字******************
#define KPasswordSwitch      @"PasswordSwitch"                  //无密开关状态的key值

#define KUserInformation     @"UserInformation"                 //登录返回用户字典的key值

#define KCashTransferUrl     @"CashTransferUrl"                 //斗金URL


#define KFingerIdentySwitch  [[WJGlobalVariable sharedInstance].defaultPerson.userID stringByAppendingString:@"KFingerIdentySwitch"]   //指纹开关是否开启key

#define kTrueString(A)       ((A) == nil? @"":(A))


#define KTap3DTouchIndex      @"KTap3DTouchIndex"     //标记从3DTouch进来点击的第几个标签

#define kServerTimeSubLocal         @"ServerTimeSubLocal"

#define kTokenForChangePhone        @"TokenForChangePhone"      //未登录修改手机号临时Token、找回密码所需状态值
//******************



//keychain关键字

#define KeychainService         @"com.wjika.wjikaios"
#define KeychainAccount         @"uuidtwo"

#ifdef ISIH

    #define KAppURLScheme           @"wanjikaClientIH"
    #define KBundleID               @"com.wjika.wjicard.clientIH"

#else

    #define KAppURLScheme           @"wanjikaClient"
    #define KBundleID               @"com.wjika.wjikaios"

#endif


//通知关键字

#define kNoLogin                    @"noLogin"                  //token失效
#define kTabCustomVCResponse        @"tabCustomVCResponse"      //tab定制页面刷新
#define kTabCustomVCGoOutVC         @"TabCustomVCGoOutVC"       //tab定制页面退出

#define kTabHomeRefresh             @"RefreshHome"         //tab首页刷新
#define kTabThirdShopRefresh        @"RefreshThirdShop"         //tab店铺刷新
#define kTabShopCartVCRefresh       @"RefreshMyShoppingCart"    //tab购物车刷新
#define kTabIndividualCenterRefresh @"RefreshIndividualCenter"  //tab个人中心刷新

#define kDeleteOrderSuccess         @"deleteOrderSuccess"       //删除订单
#define kUserIdToWeb                @"UserIdToWeb"              //useid给H5



#define NumberToString(a)          [NSString stringWithFormat:@"%@", @(a)]
#define ToString(x)  [x isKindOfClass:[NSString class]] ? x : ([x isKindOfClass:[NSNumber class]] ? [NSString stringWithFormat:@"%@", x] : nil)
#define ToNSNumber(x) [x isKindOfClass:[NSNumber class]] ? x : ([x isKindOfClass:[NSString class]] ? @([x doubleValue]) : @(INT32_MAX))


#define PlaceholderImage [UIImage imageNamed:@"share_default_picture"]
#define ClippingCenterImageUrl(baseImageUrl, dotWidth, dotHeight) [NSString stringWithFormat:@"%@?width=%@&height=%@&mode=crop&anchor=center", baseImageUrl, @((int)dotWidth*[UIScreen mainScreen].scale), @((int)dotHeight*[UIScreen mainScreen].scale)]

#define ALERT(a) [[TKAlertCenter defaultCenter] postAlertWithMessage:a];

#define cashToken [[[NSUserDefaults standardUserDefaults] dictionaryForKey:KCashUser] objectForKey:@"token"]

//日志打印宏
#ifdef DEBUG

    #define NSLog(format, ...) do {                                                 \
        fprintf(stderr, "\n<-------\n");                                              \
        fprintf(stderr, "<%s : %d> %s\n",                                           \
        [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
        __LINE__, __func__);                                                        \
        (NSLog)((format), ##__VA_ARGS__);                                           \
        fprintf(stderr, "------->\n");                                              \
    } while (0)

#else

    #define NSLog(format, ...)

#endif


#endif
