//
//  WJWebViewController.m
//  WanJiCard
//
//  Created by Lynn on 15/9/30.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJWebViewController.h"

#import "WJProductDetailController.h"
#import "WJLoginController.h"

@interface WJWebViewController ()<UIWebViewDelegate,JSObjcActivityDelegate>
{
    
}

@end

@implementation WJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenTabBar = YES;
    [self.view addSubview:self.webView];
    [kDefaultCenter addObserver:self selector:@selector(userIdToWeb) name:kUserIdToWeb object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.title = self.titleStr;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hiddenLoadingView];

    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"vjia"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}


#pragma mark - JSObjcDelegate
- (void)open:(NSString *)jsonString
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *datadic = [self jsonTransformArray:jsonString];
        NSString *typeStr = [datadic objectForKey:@"type"];
        
        if ([typeStr isEqualToString:@"getUserId"]) {
            //优惠券
            if (USER_ID) {
                [self userIdToWeb];
            }else{
                WJLoginController *loginVC = [[WJLoginController alloc]init];
                loginVC.loginFrom = LoginFromWebToUserId;
                WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:nav animated:YES completion:nil];
            }
        } else if ([typeStr isEqualToString:@"goodsdetail"]){
            //商品详情
            WJProductDetailController * productDetailVC = [[WJProductDetailController alloc]init];
            productDetailVC.productId = [NSString stringWithFormat:@"%@",datadic[@"goods_id"]];
            [self.navigationController pushViewController:productDetailVC animated:YES];
        }
        
    });
}

- (void)userIdToWeb
{
    NSString * userIdStr = [NSString stringWithFormat:@"%@",USER_ID];
    [self.jsContext[@"setUserId"] callWithArguments:@[userIdStr]];
}

- (NSDictionary *)jsonTransformArray:(NSString *)jsonString
{
    NSData *argsData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *argsDic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:argsData options:kNilOptions error:NULL];
    return argsDic;
}

#pragma mark - Logic
- (void)loadWeb:(NSString *)urlString{
    [self showLoadingView];
    NSURLRequest * request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    [self.webView loadRequest:request];
}

#pragma mark - 属性访问

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, kScreenHeight)];
        _webView.delegate = self;
        [_webView setScalesPageToFit:YES];
    }
    return _webView;
}

@end
