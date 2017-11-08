//
//  WJMyVipCardViewController.m
//  HuPlus
//
//  Created by reborn on 16/12/22.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJMyVipCardViewController.h"
#import "WJVipCardView.h"
#import "WJVipCardRechargeViewController.h"
@interface WJMyVipCardViewController ()<WJVipCardViewDelegate>
@property(nonatomic,strong) WJVipCardView *vipCardView;

@end

@implementation WJMyVipCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的会员卡";
    self.isHiddenTabBar = YES;
    [self gradientLayerWithView:self.view];
    [self navigationSetup];
    
    [self.view addSubview:self.vipCardView];
}

- (void)navigationSetup
{
    UIButton *explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    explainButton.frame = CGRectMake(0, 0, ALD(21), ALD(21));
    [explainButton setImage:[UIImage imageNamed:@"message_icon"] forState:UIControlStateNormal];
    [explainButton addTarget:self action:@selector(explainButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:explainButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
-(void)explainButton
{
    
}

#pragma mark - WJVipCardViewDelegate
- (void)vipCardViewClickChargeRecord
{
    NSLog(@"充值记录");
}

- (void)vipCardViewClickConsumeRecord
{
    NSLog(@"消费记录");

}

-(void)vipCardViewClickCharge
{
    WJVipCardRechargeViewController *vipCardRechargeVC = [[WJVipCardRechargeViewController alloc] init];
    [self.navigationController pushViewController:vipCardRechargeVC animated:YES];
}

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

#pragma setter/getter
-(WJVipCardView *)vipCardView
{
    if (nil == _vipCardView) {
        _vipCardView = [[WJVipCardView alloc] initWithFrame:CGRectMake(ALD(10), ALD(50), kScreenWidth - ALD(20), ALD(400))];
        _vipCardView.delegate = self;
    }
    return _vipCardView;
}
@end
