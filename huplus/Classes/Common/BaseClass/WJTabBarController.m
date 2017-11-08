//
//  WJTabBarController.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/15.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJTabBarController.h"
#import "WJHomeViewController.h"
#import "WJShopViewController.h"
#import "WJActivityViewController.h"
#import "WJMyIndividualViewController.h"
#import "WJShoppingCartViewController.h"
#import "WJCustomMakeViewController.h"
#import "WJThirdShopListController.h"
#import "WJProductDetailController.h"
#import "WJThirdShopViewController.h"
#import "WJWebViewController.h"
#import "WJWKWebViewController.h"
#import "WJSystemMessageViewController.h"
#import "WJLoginController.h"
#import "WJLogisticsDetailViewController.h"

#define IMAGE_W 22
#define IMAGE_H 22
#define LABEL_W 60
#define LABEL_H 20

@interface WJTabBarController ()
{
    NSArray       *titlesArray;
    NSArray       *normalImageArray;
    NSArray       *lightImageArray;
}
@end

@implementation WJTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBar setHidden:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titlesArray = @[@"首页",@"定制",@"店铺",@"购物车",@"我的"];
    
    normalImageArray = @[@"home",@"customization",@"store",@"shopCart",@"me"];
    lightImageArray = @[@"home_select",@"customization_select",@"store_select",@"shopCart_select",@"me_select"];

    //自定义tabBar
    [self createCustomTabBarView];
    
    //关联viewController
    [self createViewControllerToTabBarView];

}

//自定义tab
- (void)createCustomTabBarView
{
    //背景
    self.backGroundIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kTabbarHeight, SCREEN_WIDTH, kTabbarHeight)];
//    backGroundIV.image = [UIImage imageNamed:@"tab_backImage"];
    _backGroundIV.backgroundColor = WJColorTabBar;
    _backGroundIV.userInteractionEnabled = YES;
    [self.view addSubview:_backGroundIV];
    
// 标签
    for (int i=0; i<titlesArray.count; i++) {
        
        CGFloat itemButWidth = SCREEN_WIDTH/titlesArray.count;
        
        UIButton * itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.tag = 10000+i;
        [itemButton addTarget:self action:@selector(clickTabBarAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backGroundIV addSubview:itemButton];
        
        UIImageView *tabImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[normalImageArray objectAtIndex:i]] highlightedImage:[UIImage imageNamed:[lightImageArray objectAtIndex:i]]];
        [itemButton addSubview:tabImageView];
        
        
        itemButton.frame = CGRectMake(i * itemButWidth, 0, itemButWidth, kTabbarHeight);
        tabImageView.frame = CGRectMake((itemButWidth-IMAGE_W)/2, 7, IMAGE_W, IMAGE_H);
        
        UILabel * itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, tabImageView.bottom, itemButWidth, LABEL_H)];
        itemLabel.text = [titlesArray objectAtIndex:i];
        itemLabel.backgroundColor = [UIColor clearColor];
        itemLabel.textAlignment = NSTextAlignmentCenter;
        itemLabel.font = WJFont10;
        [itemButton addSubview:itemLabel];
        
        if (i == 0) {
            tabImageView.highlighted = YES;
            itemLabel.textColor = WJColorMainRed;
        }else{
            tabImageView.highlighted = NO;
            itemLabel.textColor = WJColorTabNoSelect;
        }
 
    }
    
}

- (void)changeTabIndex:(NSInteger)index{
    
    UIButton * indexButton = (UIButton *)[_backGroundIV viewWithTag:10000+index];
    [self clickTabBarAction:indexButton];
    self.backGroundIV.hidden = NO;
}

- (void)clickTabBarAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    
    for (int j = 0; j<titlesArray.count; j++) {
        
        if (button.tag - 10000 == 1) {
            //记录定制前控制器
            [WJGlobalVariable sharedInstance].tabBarIndex = self.selectedIndex;
        }
        //点击的tab变选中
        if (button.tag-10000 == j) {
            ((UIImageView *)button.subviews[0]).highlighted = YES;
            ((UILabel *)button.subviews[1]).textColor = WJColorMainRed;
            
        }else{
            
            UIButton *normalBtn = [_backGroundIV viewWithTag:j+10000];
            ((UIImageView *)normalBtn.subviews[0]).highlighted = NO;
            ((UILabel *)normalBtn.subviews[1]).textColor = WJColorTabNoSelect;
        }
    }
    
    self.selectedIndex = button.tag - 10000;
    [self postControllerWithIndex:self.selectedIndex];
}

//需要通知的控制器
- (void)postControllerWithIndex:(NSInteger)index
{
    WJNavigationController *nav = (WJNavigationController *)self.selectedViewController;
    [nav dismissViewControllerAnimated:NO completion:nil];
    
    [MobClick event:[NSString stringWithFormat:@"caidan%ld",index+1]];

    if (index == 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kTabHomeRefresh object:nil];

        
    } else if (index == 1) {
        //定制页面刷新
        if (USER_ID) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kTabCustomVCResponse object:nil];
        } else {
            WJLoginController *loginVC = [[WJLoginController alloc]init];
            loginVC.loginFrom = LoginFromTabCustom;
            WJNavigationController *Navigation = [[WJNavigationController alloc] initWithRootViewController:loginVC];
            [nav presentViewController:Navigation animated:YES completion:nil];
        }
        
    } else if (index == 2) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kTabThirdShopRefresh object:nil];
        
    } else if (index == 3) {
        if (USER_ID) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kTabShopCartVCRefresh object:nil];
        } else {
            WJLoginController *loginVC = [[WJLoginController alloc]init];
            loginVC.loginFrom = LoginFromTabShopCart;
            WJNavigationController *Navigation = [[WJNavigationController alloc] initWithRootViewController:loginVC];
            [nav presentViewController:Navigation animated:YES completion:nil];
        }
    } else if (index == 4) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kTabIndividualCenterRefresh object:nil];
    }
}



//关联viewController
- (void)createViewControllerToTabBarView
{
    //首页
    WJHomeViewController *homeVC = [[WJHomeViewController alloc] init];
    [homeVC hiddenBackBarButtonItem];
    WJNavigationController *homeNav = [[WJNavigationController alloc] initWithRootViewController:homeVC];
    
    //定制
    WJCustomMakeViewController *customMakeWebVC = [[WJCustomMakeViewController alloc] init];
//    [customMakeWebVC loadWeb];
    
    //LBS店铺
//    WJShopViewController *shopVC = [[WJShopViewController alloc] init];
//    WJNavigationController *shopNav = [[WJNavigationController alloc] initWithRootViewController:shopVC];
    
    
    //第三方店铺
    WJThirdShopListController *thirdShopListVC = [[WJThirdShopListController alloc] init];
    WJNavigationController *thirdShopListVCNav = [[WJNavigationController alloc] initWithRootViewController:thirdShopListVC];
    
    
    //活动
//    WJActivityViewController *activityVC = [[WJActivityViewController alloc] init];
//    WJNavigationController *activityNav = [[WJNavigationController alloc] initWithRootViewController:activityVC];
    
    //购物车
    WJShoppingCartViewController *shoppingCartVC = [[WJShoppingCartViewController alloc] init];
    shoppingCartVC.shopCartFromController = fromTab;
    WJNavigationController *shoppingCartNav = [[WJNavigationController alloc] initWithRootViewController:shoppingCartVC];

    
     //我的
    WJMyIndividualViewController *myIndividualVC = [[WJMyIndividualViewController alloc] init];
    WJNavigationController *myIndividualNav = [[WJNavigationController alloc] initWithRootViewController:myIndividualVC];
    
//    self.viewControllers = @[homeNav,customNav,activityNav,shoppingCartNav,myIndividualNav];
    self.viewControllers = @[homeNav,customMakeWebVC,thirdShopListVCNav,shoppingCartNav,myIndividualNav];


    [self changeTabIndex:0];
}

//推送通知处理
- (void)receiveNotification{
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"PushArguments"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PushArguments"];
    
    NSDictionary *pushUserInfo = dic[@"PushUserInfo"];
    NSInteger type = [dic[@"pushType"] integerValue];
    switch (type) {
            
        case PushTypeSystem:
        {
            WJNavigationController *nav = (WJNavigationController *)self.selectedViewController;
            
            WJSystemMessageViewController *systemMessageVC = [[WJSystemMessageViewController alloc] init];
            [nav pushViewController:systemMessageVC animated:NO];
            
        }
            break;
            
        case PushTypeActivity:
        {
            NSString *linkUrl = pushUserInfo[@"idIndex"];
            NSString *title = pushUserInfo[@"h5Title"];
            WJWebViewController *web = [WJWebViewController new];
            web.titleStr = title;
            [web loadWeb:linkUrl];
            
            WJNavigationController *nav = (WJNavigationController *)self.selectedViewController;
            [nav pushViewController:web animated:YES];
        }
            break;
            
        case PushTypeProduct:
        {
            WJNavigationController *nav = (WJNavigationController *)self.selectedViewController;

            WJProductDetailController * productDetailVC = [[WJProductDetailController alloc]init];
            productDetailVC.productId = pushUserInfo[@"idIndex"];
            
            [nav pushViewController:productDetailVC animated:NO];
        
        }
            break;

            
        case PushTypeShop:
        {
            WJNavigationController *nav = (WJNavigationController *)self.selectedViewController;
            
            WJThirdShopViewController *thirdShopVC = [[WJThirdShopViewController alloc] init];
            thirdShopVC.shopId = pushUserInfo[@"idIndex"];
            [nav pushViewController:thirdShopVC animated:NO];
        }
            
            break;
            

        case PushTypeLogistics:
        {
            WJNavigationController *nav = (WJNavigationController *)self.selectedViewController;
            
            WJLogisticsDetailViewController *logisticsDetailVC = [[WJLogisticsDetailViewController alloc] init];
            logisticsDetailVC.orderId = pushUserInfo[@"idIndex"];
            [nav pushViewController:logisticsDetailVC animated:NO];
        }
            
            break;
            
            
        default:
        {
            NSLog(@"No deal");
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
