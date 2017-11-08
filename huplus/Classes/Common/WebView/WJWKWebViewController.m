//
//  WJWKWebViewController.m
//  HuPlus
//
//  Created by XT Xiong on 2017/3/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJWKWebViewController.h"

@interface WJWKWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@end

@implementation WJWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenTabBar = YES;
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self hiddenLoadingView];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.minimumFontSize = 18;
    
    WKUserContentController *userCC = config.userContentController;
    //JS调用OC 添加处理脚本
    [userCC addScriptMessageHandler:self name:@"addToCart"];
    [userCC addScriptMessageHandler:self name:@"showCamera"];
    [userCC addScriptMessageHandler:self name:@"redirect"];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"%@",message.body);
    
    if ([message.name isEqualToString:@"redirect"]) {
        NSLog(@"");
    }
    
    if ([message.name isEqualToString:@"showCamera"]) {

    }

    if ([message.name isEqualToString:@"addToCart"]) {
        NSArray *array = message.body;
    }
}



- (void)loadWeb:(NSString *)urlString{
    
    [self showLoadingView];
//        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//        NSURL *localUrl = [[NSURL alloc] initFileURLWithPath:htmlPath];
//        [self.webView loadRequest:[NSURLRequest requestWithURL:localUrl]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

}

- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-20)];
        self.webView.navigationDelegate = self;
        _webView.UIDelegate = self;

        
    }
    return _webView;
}

@end
