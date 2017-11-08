//
//  WJWebTableViewCell.m
//  HuPlus
//
//  Created by reborn on 17/3/9.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJWebTableViewCell.h"
#import <WebKit/WebKit.h>
@interface WJWebTableViewCell ()<UIWebViewDelegate,WKNavigationDelegate>
{
    UIWebView   *detailWebView;
//    WKWebView   *detailWebView;
}
@end

@implementation WJWebTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(300))];
        detailWebView.delegate = self;
        detailWebView.scrollView.bounces = NO;
        detailWebView.scrollView.scrollEnabled = NO;
        [detailWebView sizeToFit];
        detailWebView.scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:detailWebView];
        
        [detailWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
//        detailWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(300))];
//        detailWebView.scrollView.scrollEnabled = NO;
//        [self.contentView addSubview:detailWebView];
//        
//        [detailWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

    }
    return self;
}

- (void)dealloc
{
    [detailWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)configWithURL:(NSString *)urlstr
{
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLRequest * request =[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    [detailWebView loadRequest:request];
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
//
//    //获取页面高度（像素）
//    CGFloat webViewHeight= [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
//    //再次设置WebView高度（点）
//    webView.frame = CGRectMake(0, 0, webView.frame.size.width, webViewHeight);
//    [self reloadByHeight:webViewHeight];
//
//}
//
//-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    NSLog(@"%@",error);
//
//}

//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
//{
//    // 计算WKWebView高度
//    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        CGRect frame =webView.frame;
//        frame.size.height =[result doubleValue];
//        webView.frame = frame;
//        [self reloadByHeight:[result doubleValue]];
//
//    }];
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        CGFloat webViewHeight= [[detailWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
        //再次设置WebView高度（点）
        detailWebView.frame = CGRectMake(0, 0, detailWebView.frame.size.width, webViewHeight);
        [self reloadByHeight:webViewHeight];
    }
    
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
//    
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        
//        isRequest = NO;
//        
//        dispatch_async(dispatch_get_global_queue(0,0), ^{
//
//            [detailWebView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
//                
//                //获取页面高度，并重置webview的frame
//                CGFloat webViewHeight = [any doubleValue];
//                
//                CGRect frame = detailWebView.frame;
//                frame.size.height = webViewHeight;
//                detailWebView.frame = frame;
//                [self reloadByHeight:webViewHeight];
//                
//            }];
//        });
//
//    }
//    
//}


- (void)reloadByHeight:(CGFloat)height
{
    if ([self.heightDelegate respondsToSelector:@selector(reloadByHeight:)])
    {
        [self.heightDelegate reloadByHeight:height];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
