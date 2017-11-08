//
//  WJThirdShopDetailViewController.m
//  HuPlus
//
//  Created by XT Xiong on 2017/3/28.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJThirdShopDetailViewController.h"
#import "APIShareManager.h"
#import "WJShare.h"
#import "WJProductDetailController.h"
#import "WJProductListController.h"
#import <UIImageView+WebCache.h>
#import "APIThirdShopDetailManager.h"
@interface WJThirdShopDetailViewController ()<UIWebViewDelegate,JSObjcShopDetailDelegate,APIManagerCallBackDelegate,UIScrollViewDelegate>
{
    UILabel     *titleL;

    UIImageView *brandIV;
    UILabel     *titleLabel;
    UILabel     *shopTypeL;
    UILabel     *onSaleCountL;
    UILabel     *onSaleDesL;
    
    CGFloat     lastPosition;
    
    UIView      *topView;
    BOOL        isUpScrolled;
}
@property(nonatomic,strong)UIScrollView                    *bgScrollView;
@property(nonatomic,strong)APIShareManager                 *shareManager;
@property(nonatomic,strong)APIThirdShopDetailManager       *thirdShopDetailManager;

@end

@implementation WJThirdShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenTabBar = YES;
    
//    isUpScrolled = NO;
//    lastPosition = 0;
    
//    [self.view addSubview:self.bgScrollView];
    [self UISet];
//    [self.bgScrollView addSubview:self.webView];
    [self.view addSubview:self.webView];
    
    [self showLoadingView];
    [self.thirdShopDetailManager loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

//- (void)dealloc
//{
//    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
//}


-(void)UISet
{
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(144))];
    [self gradientLayerWithView:topView];
//    [self.bgScrollView addSubview:topView];
    [self.view addSubview:topView];

    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake((topView.width - ALD(200))/2, ALD(32), ALD(200), ALD(20))];
    titleL.font = WJFont15;
    titleL.textColor = WJColorWhite;
    titleL.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleL];
    
    
    brandIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), kNavBarAndStatBarHeight + ALD(10), ALD(60), ALD(60))];
    brandIV.backgroundColor = WJColorWhite;
//    brandIV.layer.cornerRadius = 3;
//    brandIV.layer.masksToBounds = YES;
//    brandIV.layer.borderColor = WJColorViewBg2.CGColor;
//    brandIV.layer.borderWidth = 0.5f;
    [topView addSubview:brandIV];
    

    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(brandIV.right + ALD(10), brandIV.origin.y + 2, kScreenWidth - ALD(22) - ALD(90) - ALD(80), ALD(20))];
    titleLabel.font = WJFont15;
    titleLabel.textColor = WJColorWhite;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:titleLabel];

    shopTypeL = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.origin.x, titleLabel.bottom + 5, ALD(50), ALD(20))];
    shopTypeL.font = WJFont12;
    shopTypeL.textColor = WJColorWhite;
    shopTypeL.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:shopTypeL];
    
    onSaleCountL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(80), brandIV.origin.y + ALD(10), ALD(80), ALD(20))];
    onSaleCountL.font = WJFont15;
    onSaleCountL.textAlignment = NSTextAlignmentRight;
    onSaleCountL.textColor = WJColorWhite;
    [topView addSubview:onSaleCountL];
    
    onSaleDesL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(80), onSaleCountL.bottom, ALD(80), ALD(20))];
    onSaleDesL.font = WJFont12;
    onSaleDesL.text = @"在售商品";
    onSaleDesL.textAlignment = NSTextAlignmentRight;
    onSaleDesL.textColor = WJColorWhite;
    [topView addSubview:onSaleDesL];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(ALD(15), ALD(32), ALD(22), ALD(22));
    [leftBtn setImage:[UIImage imageNamed:@"common_nav_btn_back_white"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    [topView bringSubviewToFront:leftBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(kScreenWidth - ALD(15) - ALD(25), ALD(32), ALD(25), ALD(25));
    [shareBtn setImage:[UIImage imageNamed:@"dark_share_icon"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:shareBtn];

}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIShareManager class]]){
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        [WJShare sendShareController:self
                             LinkURL:dic[@"turn_url"]
                             TagName:@"TAG_ProductDetail"
                               Title:dic[@"title"]
                         Description:dic[@"describe"]
                          ThumbImage:dic[@"logo_pic_url"]];
    } else if ([manager isKindOfClass:[APIThirdShopDetailManager class]]) {
        
        NSDictionary *dic = [manager fetchDataWithReformer:nil];

        self.shopModel = [[WJThirdShopListModel alloc] initWithDictionary:dic];
    
        [self refreshTopView];
        
        [self loadWeb];
    }
    
}

-(void)refreshTopView
{
    [brandIV sd_setImageWithURL:[NSURL URLWithString:self.shopModel.shopIconUrl] placeholderImage:[UIImage imageNamed:@"bitmap_brand"]];
    titleLabel.text = self.shopModel.shopName;
    
    switch (self.shopModel.storeType) {
        case 1:
        {
            shopTypeL.text = @"品牌旗舰店";
        }
            
            break;
        case 2:
        {
            shopTypeL.text = @"品牌专卖店";
        }
            
            break;
        case 3:
        {
            shopTypeL.text = @"品类专营店";
        }
            
            break;
        case 4:
        {
            shopTypeL.text = @"认证个人店";
        }
            
            break;
            
        default:
            break;
    }
    
    titleL.text = self.shopModel.shopName;

    NSString *storeTypeStr = shopTypeL.text;
    CGSize txtSize = [storeTypeStr sizeWithAttributes:@{NSFontAttributeName:WJFont12} constrainedToSize:CGSizeMake(1000000, ALD(20))];
    
    shopTypeL.frame = CGRectMake(titleLabel.origin.x, titleLabel.bottom + 5, txtSize.width + 5, ALD(20));
    shopTypeL.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"#D31838"];
    
    onSaleCountL.text = [NSString stringWithFormat:@"%ld",self.shopModel.saleCount];
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
}

- (void)shareBtn
{
    [self.shareManager loadData];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hiddenLoadingView];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
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
        NSDictionary *dic = [self jsonTransformArray:jsonString];
        NSString * typeStr = dic[@"type"];
        if ([typeStr isEqualToString:@"goodsdetail"]) {
            WJProductDetailController * productDetailVC = [[WJProductDetailController alloc]init];
            productDetailVC.productId = [NSString stringWithFormat:@"%@",dic[@"goods_id"]];
            [self.navigationController pushViewController:productDetailVC animated:YES];
        }else if ([typeStr isEqualToString:@"goodslist"]){
            WJProductListController *productListVC = [[WJProductListController alloc] init];
            productListVC.storeId = self.shopModel.shopId;
            productListVC.comeFormType = ComeFromTypeThirdShop;
            [self.navigationController pushViewController:productListVC animated:YES];
        }
        NSLog(@"%@",dic);
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
    
    NSString *urlString = self.shopModel.shopDetailUrl;
    NSURLRequest * request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    [self.webView loadRequest:request];
}


#pragma mark - UIScrollViewDelegate
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView == self.bgScrollView) {
//        
//        
//        int currentPostion = scrollView.contentOffset.y;
//        
//        if (currentPostion - lastPosition > 100  && currentPostion > 0) {
//            
//            lastPosition = currentPostion;
//            
//            NSLog(@"ScrollUp");
//            
//            [UIView animateWithDuration:1 animations:^{
//                
//                [self.bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//
//                
//                if (isUpScrolled == NO) {
//                    
//                    self.webView.frame = CGRectMake(0, kNavBarAndStatBarHeight + ALD(10),kScreenWidth, kScreenHeight - topView.height);
//                    isUpScrolled = YES;
//                    
//                }
//
//                
//            } completion:^(BOOL finished) {
//                
//            }];
//        
//            
//        } else if ((lastPosition - currentPostion > 100) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height) )
//            
//        {
//            lastPosition = currentPostion;
//            
//            NSLog(@"ScrollDown");
//            
//            [UIView animateWithDuration:1 animations:^{
//                
//                [self.bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//
//                if (isUpScrolled) {
//                    
//                    self.webView.frame = CGRectMake(0, topView.height ,kScreenWidth, kScreenHeight - topView.height);
//
//                    isUpScrolled = NO;
//                    
//                }
//
//                
//            } completion:^(BOOL finished) {
//
//            }];
//            
//            
//        }
//        
//    }
//    
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
//    
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        
//        CGFloat webViewHeight= [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
//        //再次设置WebView高度（点）
//        self.webView.frame = CGRectMake(0, 0, topView.height, webViewHeight);
//        self.bgScrollView.height = topView.height + webViewHeight;
//    }
//    
//}

#pragma mark - Custom Function
- (void)gradientLayerWithView:(UIView *)view
{
    UIColor *color1 = [WJUtilityMethod colorWithHexColorString:@"#f11c61"];
    UIColor *color2 = [WJUtilityMethod colorWithHexColorString:@"#fb551b"];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0),@(1.0),nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(1, 1);
    
}


#pragma mark - 属性访问
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, topView.height, kScreenWidth, kScreenHeight - topView.height)];

        _webView.delegate = self;
        [_webView setScalesPageToFit:YES];
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = YES;
        
//        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

        
    }
    return _webView;
}

//-(UIScrollView *)bgScrollView
//{
//    if (!_bgScrollView) {
//        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, - kStatusBarHeight, kScreenWidth, kScreenHeight + kStatusBarHeight)];
//        _bgScrollView.delegate = self;
//        _bgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
//        _bgScrollView.contentOffset = CGPointMake(0, 0);
//        _bgScrollView.showsVerticalScrollIndicator = NO;
//    }
//    return _bgScrollView;
//    
//}

- (APIShareManager *)shareManager
{
    if (!_shareManager) {
        _shareManager = [[APIShareManager alloc]init];
        _shareManager.delegate = self;
    }
    return _shareManager;
}

-(APIThirdShopDetailManager *)thirdShopDetailManager
{
    if (!_thirdShopDetailManager) {
        _thirdShopDetailManager = [[APIThirdShopDetailManager alloc] init];
        _thirdShopDetailManager.delegate = self;
    }
    _thirdShopDetailManager.shopId = self.shopId;
    return _thirdShopDetailManager;
}

@end
