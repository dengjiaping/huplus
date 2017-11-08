//
//  WJCustomMakeViewController.h
//  HuPlus
//
//  Created by XT Xiong on 2017/3/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcCustomDelegate <JSExport>

- (void)addToCart:(NSString *)jsonString;
- (void)redirect:(NSString *)jsonString;
- (void)showCamera:(NSString *)jsonString;
- (void)showTitle:(NSString *)jsonString;


@end

@interface WJCustomMakeViewController : WJViewController

@property (nonatomic, strong) UIWebView             * webView;
@property (nonatomic, strong) NSString              * titleStr;
@property (nonatomic, strong) JSContext             * jsContext;

- (void)loadWeb;

@end
