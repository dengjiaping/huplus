//
//  WJShopViewController.m
//  HuPlus
//
//  Created by XT Xiong on 16/12/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJShopViewController.h"
#import "WJShopListView.h"
#import "WJShopMapView.h"

#import "WJShopDetailController.h"
#import "WJLoginController.h"

@interface WJShopViewController ()
{
    BOOL     isMap;
}

@property(nonatomic,strong)WJShopListView               *shopListTV;
@property(nonatomic,strong)WJShopMapView                *shopMapView;


@end

@implementation WJShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺";
    isMap = false;
    [self hiddenBackBarButtonItem];
    
    [self navigationSetUp];
    [self.view addSubview:self.shopListTV];
    [self.view addSubview:self.shopMapView];
//    self.shopListTV.hidden = YES;
    self.shopMapView.hidden = YES;
    [self listBlockPushNextVC];
}



#pragma mark - Cusitom Function

- (void)listBlockPushNextVC
{
    __block typeof(self) blockSelf = self;
    self.shopListTV.indexPathBlock = ^(NSIndexPath *indexPath){
        
        WJShopDetailController * shopDetailVC = [[WJShopDetailController alloc]init];
        [blockSelf.navigationController pushViewController:shopDetailVC animated:YES];
    };
}

- (void)navigationSetUp{
    
    UIButton * addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressButton setTitle:@"北京" forState:UIControlStateNormal];
    [addressButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
    [addressButton.titleLabel setFont:WJFont14];
    [addressButton setFrame:CGRectMake(0, 0, ALD(40), ALD(30))];
    [addressButton addTarget:self action:@selector(addressButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithCustomView:addressButton];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(0, 0, 25, 25);
    [mapBtn setImage:[UIImage imageNamed:@"map_icon"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(mapButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mapBarBtn = [[UIBarButtonItem alloc] initWithCustomView:mapBtn];
    
    self.navigationItem.rightBarButtonItem = mapBarBtn;
    
}


- (void)addressButton
{
    
}

- (void)mapButton:(UIButton *)button
{
    if (self.shopMapView.hidden) {
        [button setImage:[UIImage imageNamed:@"list_icon"] forState:UIControlStateNormal];
        self.shopListTV.hidden = YES;
        self.shopMapView.hidden = NO;
    }else{
        [button setImage:[UIImage imageNamed:@"map_icon"] forState:UIControlStateNormal];
        self.shopMapView.hidden = YES;
        self.shopListTV.hidden = NO;
    }
    [self viewAnimation];
}

- (void)viewAnimation
{
    CABasicAnimation *animation1 = [ CABasicAnimation animationWithKeyPath:@"transform"];
    animation1.fromValue = [ NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0)];
    animation1.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation1.duration = 0.5;
    animation1.cumulative = YES;
    [self.view.layer addAnimation:animation1 forKey:nil];
}

- (WJShopListView *)shopListTV
{
    if (_shopListTV == nil) {
        _shopListTV = [[WJShopListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _shopListTV;
}

- (WJShopMapView *)shopMapView
{
    if (_shopMapView == nil) {
        _shopMapView = [[WJShopMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _shopMapView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
