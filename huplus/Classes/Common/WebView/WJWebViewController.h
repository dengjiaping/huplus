//
//  WJWebViewController.h
//  WanJiCard
//
//  Created by Lynn on 15/9/30.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcActivityDelegate <JSExport>

- (void)open:(NSString *)jsonString;


@end

@interface WJWebViewController : WJViewController

@property (nonatomic, strong) UIWebView             * webView;
@property (nonatomic, strong) NSString              * titleStr;
@property (nonatomic, strong) JSContext             * jsContext;



- (void)loadWeb:(NSString *)urlString;

@end
