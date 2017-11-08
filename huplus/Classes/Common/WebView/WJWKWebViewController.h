//
//  WJWKWebViewController.h
//  HuPlus
//
//  Created by XT Xiong on 2017/3/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>


@interface WJWKWebViewController : WJViewController

@property (nonatomic, strong) WKWebView             * webView;
@property (nonatomic, strong) NSString              * titleStr;
@property (nonatomic, strong) JSContext             * jsContext;

- (void)loadWeb:(NSString *)urlString;

@end
