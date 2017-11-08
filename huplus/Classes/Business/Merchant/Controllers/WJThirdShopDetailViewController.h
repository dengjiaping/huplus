//
//  WJThirdShopDetailViewController.h
//  HuPlus
//
//  Created by XT Xiong on 2017/3/28.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WJThirdShopListModel.h"

@protocol JSObjcShopDetailDelegate <JSExport>

- (void)open:(NSString *)type json:(NSString *)jsonString;

- (void)open:(NSString *)jsonString;

- (void)redirect:(NSString *)jsonString;
- (void)showCamera:(NSString *)jsonString;

@end

@interface WJThirdShopDetailViewController : WJViewController

@property (nonatomic, strong) UIWebView             * webView;
@property (nonatomic, strong) NSString              * titleStr;
@property (nonatomic, strong) JSContext             * jsContext;
@property (nonatomic, strong) NSString              * shopId;
@property (nonatomic, strong) WJThirdShopListModel  *shopModel;
@end
