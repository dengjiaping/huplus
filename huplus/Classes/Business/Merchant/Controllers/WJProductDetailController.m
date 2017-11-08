//
//  WJProductDetailController.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/29.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJProductDetailController.h"
#import "WJBottonBarView.h"
#import "WJCustomBannerView.h"
#import "WJProductDetailIntroductionCell.h"
#import "WJProductDetailBandCell.h"
#import "WJProductDetailHeadCell.h"
#import "WJProductDetailCell.h"
#import "WJShare.h"
#import "APIShareManager.h"

#import "WJChooseGoodsPropertyController.h"
#import "WJBrandDetailController.h"
#import "APIProductDetailManager.h"
#import "WJProductDetailReformer.h"
#import "WJProductDetailModel.h"
#import "APIAddCollectionManager.h"
#import "APIDeleteCollectionManager.h"
#import "APIShopCartCountManager.h"
#import "WJShoppingCartViewController.h"
#import "WJWebViewController.h"
#import "WJWebTableViewCell.h"
#import "WJLoginController.h"
#import "WJThirdShopDetailViewController.h"
#import "WJSystemAlertView.h"


@interface WJProductDetailController ()<UITableViewDataSource, UITableViewDelegate,APIManagerCallBackDelegate,ReloadWebViewDelegate>
{
    UILabel       *badgeLabel;
    NSInteger     shoppingCarCount;
    CGFloat       productDetailCellHight;
}
@property(nonatomic,strong)UITableView                     * mainTableView;
@property(nonatomic,strong)WJBottonBarView                 * bottonBarView;
@property(nonatomic,strong)WJCustomBannerView              * bannerView;

@property(nonatomic,strong)APIProductDetailManager         * productDetailManager;
@property(nonatomic,strong)APIAddCollectionManager         * addCollectionManager;
@property(nonatomic,strong)APIDeleteCollectionManager      * deleteCollectionManager;
@property(nonatomic,strong)APIShopCartCountManager         * shopCartCountManager;
@property(nonatomic,strong)APIShareManager                 * shareManager;


@property(nonatomic,strong)WJProductDetailModel            * productDetailModel;
@property(nonatomic,strong)NSArray                         * productDetailArray;//描述
@property(nonatomic,strong)NSArray                         * attributeListArray;//属性
@property(nonatomic,strong)NSMutableArray                  * bannerArray;

@end

@implementation WJProductDetailController


#pragma mark - Life Ciryle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    self.isHiddenTabBar = YES;

    [self navigationSetUp];
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.bottonBarView];
    [self.view addConstraints:[_bottonBarView constraintsSize:CGSizeMake(kScreenWidth, kTabbarHeight)]];
    [self.view addConstraints:[_bottonBarView constraintsLeftInContainer:0]];
    [self.view addConstraints:[_bottonBarView constraintsBottomInContainer:0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"refreshProductDetailCount" object:nil];
    
    [self requestData];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)requestData
{
    [self showLoadingView];
    [self.productDetailManager loadData];
    self.view.userInteractionEnabled = NO;
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    self.view.userInteractionEnabled = YES;

    if ([manager isKindOfClass:[APIProductDetailManager class]]) {
        self.productDetailModel  = [manager fetchDataWithReformer:[[WJProductDetailReformer alloc] init]];
        
        self.bannerArray = self.productDetailModel.bannerListArray;
        self.productDetailArray = self.productDetailModel.descriptionListArray;
        self.attributeListArray = self.productDetailModel.attributeListArray;

        if (self.productDetailModel.isColletion) {
            self.bottonBarView.collectButton.selected  = YES;
        } else {
            self.bottonBarView.collectButton.selected  = NO;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShoppingCartCount) name:@"ShoppingCartCountRefresh" object:nil];
        
        [self.mainTableView reloadData];

        [self.shopCartCountManager loadData];
        
    } else if ([manager isKindOfClass:[APIAddCollectionManager class]]){
        self.bottonBarView.collectButton.selected = !self.bottonBarView.collectButton.selected;
        self.productDetailModel.isColletion = YES;
        ALERT(@"收藏成功");

    } else if ([manager isKindOfClass:[APIDeleteCollectionManager class]]) {
        self.bottonBarView.collectButton.selected = !self.bottonBarView.collectButton.selected;
        self.productDetailModel.isColletion = NO;
        ALERT(@"取消收藏");

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
        [self.mainTableView reloadData];

    }else if ([manager isKindOfClass:[APIShareManager class]]){
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        [WJShare sendShareController:self
                                 LinkURL:dic[@"turn_url"]
                                 TagName:@"TAG_ProductDetail"
                                   Title:dic[@"title"]
                             Description:dic[@"describe"]
                              ThumbImage:dic[@"logo_pic_url"]];
    }
    
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
    
    if (manager.errorCode == 10000001) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDelagate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (!self.productDetailModel) {
        return 10;
//    }else{
//        self.bottonBarView.hidden = YES;
//        return 0;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
            return ALD(375); //轮播
    }else if (indexPath.row == 1){

        //简介
        if ([self.productDetailModel.originalPrice isEqualToString:@""]) {
            return 135;
        } else {
            return 160;
        }
        
    }else if (indexPath.row == 3){
        return 60; //品牌
    }else if (indexPath.row == 5){
        
        if (self.productDetailArray.count > 0) {
            return 40; //商品描述抬头
            
        } else {
            return 0;
        }
        
    }else if (indexPath.row == 6){
        
        if (self.productDetailArray.count > 0) {
            return self.productDetailArray.count * 35 + 30; //商品描述

        } else {
            return 0;
        }
    }else if (indexPath.row == 8){
//        return 40; //商品详情抬头
        return 0;
    }else if (indexPath.row == 9){
        return productDetailCellHight; //商品详情
    }else{
    
        //分割
        if (indexPath.row == 2 || indexPath.row == 4) {
            return 10;
        }else{
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //轮播
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BannerCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.bannerArray.count > 0) {

            self.bannerView = [WJCustomBannerView CreateBannerViewWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(375)) imageArray:self.bannerArray timerWithTimeInterval:1 imageClickBlock:^(NSInteger imageIndex) {
                NSLog(@"点击第%ld张轮播图",imageIndex);
            }];
            [self.bannerView pasueTimer];
        }
 
        [cell.contentView addSubview:self.bannerView];
        return cell;
    }else if (indexPath.row == 1){
        //简介
        WJProductDetailIntroductionCell * cell = [[WJProductDetailIntroductionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProductDetailIntroductionCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configDataWithName:self.productDetailModel.productName price:self.productDetailModel.price originalPrice:self.productDetailModel.originalPrice];
        return cell;
    }else if (indexPath.row == 3){
        //品牌
        WJProductDetailBandCell * cell = [[WJProductDetailBandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProductDetailBandCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell configDataWithImage:self.productDetailModel.shopImgurl shopName:self.productDetailModel.shopName onSaleCount:self.productDetailModel.onSaleCount];
        
        return cell;
    }else if (indexPath.row == 5){
        //商品描述抬头
        WJProductDetailHeadCell * cell = [[WJProductDetailHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProductDetailHeadCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"商品描述";
        return cell;
    }else if (indexPath.row == 6){
        //商品描述
        WJProductDetailCell * cell = [[WJProductDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProductDetailCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configDataWithModel:self.productDetailArray];
//        NSLog(@"WJProductDetailCell:%f",cell.frame.origin.x);

        return cell;
    }else if (indexPath.row == 8){
        //商品详情抬头
        WJProductDetailHeadCell * cell = [[WJProductDetailHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProductDetailHeadCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"商品详情";
        return cell;
    }else if (indexPath.row == 9){
        //商品详情
        WJWebTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WebCell"];
        if (!cell) {
            cell = [[WJWebTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WebCell"];
            cell.heightDelegate = self;

        }
        if (self.productDetailModel != nil && productDetailCellHight == 0) {
            [cell configWithURL:self.productDetailModel.detailUrl];
        }
        cell.contentView.backgroundColor = WJRandomColor;
        return cell;
        
    }else{
        //分割
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorViewBg;

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {

        WJThirdShopDetailViewController *thirdShopVC = [[WJThirdShopDetailViewController alloc] init];
        thirdShopVC.shopId = self.productDetailModel.shopId;
        [self.navigationController pushViewController:thirdShopVC animated:NO];
    }
}

#pragma mark - Custom Function
- (void)navigationSetUp{
    UIButton *shoppingCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingCartBtn.frame = CGRectMake(0, 0, 40, 25);
    [shoppingCartBtn setImage:[UIImage imageNamed:@"Shopping_cart_icon"] forState:UIControlStateNormal];
    [shoppingCartBtn addTarget:self action:@selector(shoppingCartBtn) forControlEvents:UIControlEventTouchUpInside];
    //添加小红点
    badgeLabel = [[UILabel alloc]initForAutoLayout];
    [shoppingCartBtn addSubview:badgeLabel];
    [shoppingCartBtn addConstraints:[badgeLabel constraintsSize:CGSizeMake(15, 15)]];
    [shoppingCartBtn addConstraints:[badgeLabel constraintsBottomInContainer:12]];
    [shoppingCartBtn addConstraints:[badgeLabel constraintsRightInContainer:-1]];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.font = WJFont10;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.backgroundColor = [UIColor redColor];
    badgeLabel.layer.cornerRadius = 15/2;
    badgeLabel.layer.masksToBounds = YES;
    badgeLabel.hidden = YES;
    
    UIBarButtonItem *shoppingCartBarBtn = [[UIBarButtonItem alloc] initWithCustomView:shoppingCartBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 25, 25);
    [shareBtn setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:shareBarBtn,shoppingCartBarBtn, nil];
}

#pragma mark - ReloadWebViewDelegate
- (void)reloadByHeight:(CGFloat)height
{
    productDetailCellHight = height;
    [self.mainTableView reloadData];
}

#pragma mark - Button Action
- (void)collectButtonAction
{
    [MobClick event:@"xq_shoucang"];

    if (USER_ID) {
        
        if (self.productDetailModel.isColletion) {
            
            [self.deleteCollectionManager loadData];
            
        } else {
            
            [self.addCollectionManager loadData];
        }
        
        
    } else {
        
        WJLoginController *loginVC = [[WJLoginController alloc]init];
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
        
}

- (void)addShopCarButtonAction
{
    [MobClick event:@"xq_gwc2"];

    if (USER_ID) {
        
        WJChooseGoodsPropertyController * chooseGoodsVC = [[WJChooseGoodsPropertyController alloc]init];
        chooseGoodsVC.productDetailModel = self.productDetailModel;
        chooseGoodsVC.toNextController = ToAddShoppingCart;
        chooseGoodsVC.isFromProductDetail = YES;
        chooseGoodsVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self addChildViewController:chooseGoodsVC];
        [self.view addSubview:chooseGoodsVC.view];
        
    } else {
        
        WJLoginController *loginVC = [[WJLoginController alloc]init];
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
}

- (void)buyNowButtonAction
{
    [MobClick event:@"xq_buy"];

    if (USER_ID) {
        
        [WJGlobalVariable sharedInstance].payfromController = self;

        WJChooseGoodsPropertyController * chooseGoodsVC = [[WJChooseGoodsPropertyController alloc]init];
        chooseGoodsVC.productDetailModel = self.productDetailModel;
        chooseGoodsVC.toNextController = ToConfirmOrderController;
        chooseGoodsVC.isFromProductDetail = YES;
        chooseGoodsVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self addChildViewController:chooseGoodsVC];
        [self.view addSubview:chooseGoodsVC.view];
        
    } else {
        
        WJLoginController *loginVC = [[WJLoginController alloc]init];
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
}

- (void)shoppingCartBtn
{
    [MobClick event:@"xq_gwc1"];
    if (USER_ID) {
        WJShoppingCartViewController *shoppingCartVC = [[WJShoppingCartViewController alloc] init];
        shoppingCartVC.shopCartFromController = fromProductDetailControllert;
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:shoppingCartVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
    } else {
        WJLoginController *loginVC = [[WJLoginController alloc]init];
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
}

- (void)shareBtn
{
    [MobClick event:@"xq_fenxiang"];
    [self.shareManager loadData];
}

-(void)refreshShoppingCartCount
{
    [self.shopCartCountManager loadData];
}

#pragma mark - Setter And Getter
- (UITableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabbarHeight) style:UITableViewStylePlain];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

- (WJBottonBarView *)bottonBarView
{
    if (_bottonBarView == nil) {
        _bottonBarView = [[WJBottonBarView alloc]initForAutoLayout];
        _bottonBarView.backgroundColor = WJColorWhite;
        [_bottonBarView.collectButton addTarget:self action:@selector(collectButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottonBarView.addShopCarButton addTarget:self action:@selector(addShopCarButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottonBarView.buyNowButton addTarget:self action:@selector(buyNowButtonAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _bottonBarView;
}

-(NSMutableArray *)bannerArray
{
    if (nil == _bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSArray *)productDetailArray
{
    if (_productDetailArray == nil) {
        _productDetailArray = [NSArray array];

    }
    return _productDetailArray;
}

-(NSArray *)attributeListArray
{
    if (_attributeListArray == nil) {
        _attributeListArray = [NSArray array];
    }
    return _attributeListArray;
}

-(APIProductDetailManager *)productDetailManager
{
    if (_productDetailManager == nil) {
        _productDetailManager = [[APIProductDetailManager alloc] init];
        _productDetailManager.delegate = self;
    }
    _productDetailManager.userId = USER_ID;
    _productDetailManager.productId = self.productId;

    return _productDetailManager;
}

-(APIAddCollectionManager *)addCollectionManager
{
    if (_addCollectionManager == nil) {
        _addCollectionManager = [[APIAddCollectionManager alloc] init];
        _addCollectionManager.delegate = self;
    }
    _addCollectionManager.userId = USER_ID;
    _addCollectionManager.productId = self.productId;
    return _addCollectionManager;
}

-(APIDeleteCollectionManager *)deleteCollectionManager
{
    if (_deleteCollectionManager == nil) {
        _deleteCollectionManager = [[APIDeleteCollectionManager alloc] init];
        _deleteCollectionManager.delegate = self;
    }
    _deleteCollectionManager.userId = USER_ID;
    _deleteCollectionManager.productId = self.productId;
    return _deleteCollectionManager;
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

- (APIShareManager *)shareManager
{
    if (_shareManager == nil) {
        _shareManager = [[APIShareManager alloc]init];
        _shareManager.delegate = self;
    }
    return _shareManager;
}


@end
