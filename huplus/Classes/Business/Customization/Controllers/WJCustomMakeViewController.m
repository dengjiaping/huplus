//
//  WJCustomMakeViewController.m
//  HuPlus
//
//  Created by XT Xiong on 2017/3/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJCustomMakeViewController.h"
#import "WJTabBarController.h"
#import "AppDelegate.h"
#import "WJSystemAlertView.h"
#import "UIImageView+WebCache.h"
#import "APIShopCartCountManager.h"


#import "WJCameraController.h"
#import "WJLoginController.h"
#import "WJShoppingCartViewController.h"
#import "APIAddShoppingCartManager.h"

@interface WJCustomMakeViewController ()<UIWebViewDelegate,JSObjcCustomDelegate,APIManagerCallBackDelegate,WJSystemAlertViewDelegate>
{
    UILabel       *badgeLabel;
    NSInteger     shoppingCarCount;
    BOOL          isRequesting;
}

@property(nonatomic,strong)APIAddShoppingCartManager   * addShoppingCartManager;
@property(nonatomic,strong)APIShopCartCountManager     * shopCartCountManager;
@property(nonatomic,strong)UIButton                    * leftBtn;
@property(nonatomic,strong)UIButton                    * shoppingCartBtn;
@property(nonatomic,strong)NSString                    *firstProductId;
@property(nonatomic,strong)NSString                    *sectionProductId;

@end

@implementation WJCustomMakeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    [self.shopCartCountManager loadData];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.tabBarController.backGroundIV.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self custionView];
    
    [kDefaultCenter addObserver:self selector:@selector(refreshCustomVC) name:kTabCustomVCResponse object:nil];
    [kDefaultCenter addObserver:self selector:@selector(goOutVC) name:kTabCustomVCGoOutVC object:nil];

}

- (void)custionView
{
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(15, 32, 22, 22);
    [_leftBtn setImage:[UIImage imageNamed:@"common_nav_btn_back"] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(backBarButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBtn];
    
    self.shoppingCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shoppingCartBtn.frame = CGRectMake(kScreenWidth - 40 - 15, 32, 40, 25);
    [_shoppingCartBtn setImage:[UIImage imageNamed:@"Shopping_cart_icon"] forState:UIControlStateNormal];
    [_shoppingCartBtn addTarget:self action:@selector(shoppingCartBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shoppingCartBtn];
    //添加小红点
    badgeLabel = [[UILabel alloc]initForAutoLayout];
    [_shoppingCartBtn addSubview:badgeLabel];
    [_shoppingCartBtn addConstraints:[badgeLabel constraintsSize:CGSizeMake(15, 15)]];
    [_shoppingCartBtn addConstraints:[badgeLabel constraintsBottomInContainer:12]];
    [_shoppingCartBtn addConstraints:[badgeLabel constraintsRightInContainer:-1]];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.font = WJFont10;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.backgroundColor = [UIColor redColor];
    badgeLabel.layer.cornerRadius = 15/2;
    badgeLabel.layer.masksToBounds = YES;
    badgeLabel.hidden = YES;
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIAddShoppingCartManager class]]) {
        //统一接口请求结束后再二次请求
        if (isRequesting == YES) {
            
            if (![self.firstProductId  isEqualToString:self.sectionProductId]) {
                
                self.addShoppingCartManager.productId = self.sectionProductId;
                [self.addShoppingCartManager loadData];
                isRequesting = NO;
                
            } else {
                
                isRequesting = NO;
                [self.shopCartCountManager loadData];
                ALERT(@"已添加至购物车");
                return;
            }
        }
        
        [self.shopCartCountManager loadData];

    } else if ([manager isKindOfClass:[APIShopCartCountManager class]]) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        shoppingCarCount = [dic[@"cart_count"] integerValue];
        if (shoppingCarCount > 0) {
            badgeLabel.hidden = NO;
            if (shoppingCarCount < 10) {
                badgeLabel.size = CGSizeMake(15, 15);
            }else{
                badgeLabel.size = CGSizeMake(22, 15);
            }
            badgeLabel.text = [NSString stringWithFormat:@"%ld",(long)shoppingCarCount];
        }else{
            badgeLabel.hidden = YES;
        }
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hiddenLoadingView];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"wjika"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if (response.statusCode > 400) {
        [self hiddenLoadingView];
        [self alertShow];
        return NO;
    }
    return YES;
}

#pragma mark - WJSystemAlertViewDelegate

- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WJTabBarController * tab = (WJTabBarController *)self.tabBarController;
    if([WJGlobalVariable sharedInstance].tabBarIndex != 1){
        [tab changeTabIndex:[WJGlobalVariable sharedInstance].tabBarIndex];
    }
}

- (void)alertShow
{
    WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:@"网络错误" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
    [alert showIn];
}

#pragma mark - Button Acti on
- (void)backBarButton
{
    [self goOutVC];
}

- (void)shoppingCartBtnAction
{
    WJShoppingCartViewController *shoppingCartVC = [[WJShoppingCartViewController alloc] init];
    shoppingCartVC.shopCartFromController = fromProductDetailControllert;
    WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:shoppingCartVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - JSObjcDelegate
- (void)showCamera:(NSString *)jsonString
{
    dispatch_async(dispatch_get_main_queue(), ^{
        WJCameraController *cameraVC = [[WJCameraController alloc]init];
        cameraVC.cameraControllerBlock = ^(NSDictionary *dataDic){
            NSString * urlString = [dataDic objectForKey:@"head_portrait"];
            [self.jsContext[@"pushPhoto"] callWithArguments:@[urlString]];
        };
        [self presentViewController:cameraVC animated:YES completion:nil];
    });
}

- (void)showTitle:(NSString *)jsonString
{
    //头部按钮的显隐
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *showStr = [[self jsonTransformArray:jsonString] objectForKey:@"show"];
        if ([showStr isEqualToString:@"0"]) {
            self.shoppingCartBtn.hidden = YES;
            self.leftBtn.hidden = YES;
        }else{
            self.shoppingCartBtn.hidden = NO;
            self.leftBtn.hidden = NO;
        }
    });
}

- (void)redirect:(NSString *)jsonString
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *string = [[self jsonTransformArray:jsonString] objectForKey:@"type"];
        if ([string isEqualToString:@"cart"]) {
            WJShoppingCartViewController *shoppingCartVC = [[WJShoppingCartViewController alloc] init];
            shoppingCartVC.shopCartFromController = fromProductDetailControllert;
            WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:shoppingCartVC];
            [self presentViewController:nav animated:YES completion:nil];
        }else if ([string isEqualToString:@"back"]){
            [self goOutVC];
        }
    });
}

- (void)addToCart:(NSString *)jsonString
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *datadic = [self jsonTransformArray:jsonString];
        self.addShoppingCartManager.productId = datadic[@"goods_id"];
        self.addShoppingCartManager.skuId = datadic[@"sku_id"];
        self.addShoppingCartManager.productCount = 1;
        self.sectionProductId = datadic[@"goods_id"];
        
        if (isRequesting == NO) {
            self.firstProductId = datadic[@"goods_id"];
            self.addShoppingCartManager.productId = self.firstProductId;
            [self.addShoppingCartManager loadData];
            isRequesting = YES;
        }
    });
}

- (NSDictionary *)jsonTransformArray:(NSString *)jsonString
{
    NSData *argsData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *argsDic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:argsData options:kNilOptions error:NULL];
    return argsDic;
}

#pragma mark - Logic
- (void)loadWeb{
    [self showLoadingView];
    NSString *urlString = [NSString stringWithFormat:@"http://static.ihujia.com/custom/dist/?user_id=%@#/",USER_ID];
    NSURLRequest * request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    [self.webView loadRequest:request];
}

//通知刷新
- (void)refreshCustomVC
{
    [self loadWeb];
}

- (void)goOutVC
{
    WJTabBarController * tab = (WJTabBarController *)self.tabBarController;
    if([WJGlobalVariable sharedInstance].tabBarIndex != 1){
        [tab changeTabIndex:[WJGlobalVariable sharedInstance].tabBarIndex];
    }
}



#pragma mark - 属性访问

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-20)];
        _webView.delegate = self;
        [_webView setScalesPageToFit:YES];
        _webView.scrollView.bounces = NO;
    }
    return _webView;
}

-(APIAddShoppingCartManager *)addShoppingCartManager
{
    if (_addShoppingCartManager == nil) {
        _addShoppingCartManager = [[APIAddShoppingCartManager alloc] init];
        _addShoppingCartManager.delegate = self;
    }
    _addShoppingCartManager.userId = USER_ID;
    return _addShoppingCartManager;
}

-(APIShopCartCountManager *)shopCartCountManager
{
    if (_shopCartCountManager == nil) {
        _shopCartCountManager = [[APIShopCartCountManager alloc] init];
        _shopCartCountManager.delegate = self;
    }
    _shopCartCountManager.userId = USER_ID;
    return _shopCartCountManager;
}

@end
