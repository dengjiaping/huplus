//
//  WJPayResultViewController.m
//  HuPlus
//
//  Created by reborn on 17/1/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJPayResultViewController.h"
#import "AppDelegate.h"
#import "WJMyOrderController.h"
#import "WJOrderDetailController.h"
#import "WJProductDetailController.h"
#import "WJShoppingCartViewController.h"
@interface WJPayResultViewController ()

@end

@implementation WJPayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付成功";
    self.isHiddenTabBar = YES;
    // Do any additional setup after loading the view.
    
    [self UISetUp];
}

-(void)UISetUp
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(260))];
    bgView.backgroundColor = WJColorWhite;
    [self.view addSubview:bgView];
    
    UIImage *img =  [UIImage imageNamed:@"payment-success_icon"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.width - img.size.width)/2, ALD(30), img.size.width, img.size.height)];
    imageView.image = img;
    [bgView addSubview:imageView];
    
    UILabel *exchangeDesL = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - ALD(80))/2, imageView.bottom + ALD(10), ALD(80), ALD(20))];
    exchangeDesL.text = @"支付成功";
    exchangeDesL.textAlignment = NSTextAlignmentCenter;
    exchangeDesL.font = WJFont15;
    exchangeDesL.backgroundColor = [UIColor clearColor];
    [bgView addSubview:exchangeDesL];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), exchangeDesL.bottom + ALD(30), kScreenWidth - ALD(24), 1)];
    lineView.backgroundColor = WJColorSeparatorLine;
    [bgView addSubview:lineView];
    
    UILabel *exchangeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), lineView.bottom + ALD(25), ALD(80), ALD(20))];
    exchangeL.text = @"支付金额";
    exchangeL.textColor = WJColorNavigationBar;
    exchangeL.font = WJFont14;
    exchangeL.backgroundColor = [UIColor clearColor];
    [bgView addSubview:exchangeL];
    
    UILabel *exchangeAmountL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(150), exchangeL.frame.origin.y, ALD(150), ALD(20))];
    exchangeAmountL.text = [NSString stringWithFormat:@"¥%.2f",[self.totleCash floatValue]];

    exchangeAmountL.textAlignment = NSTextAlignmentRight;
    exchangeAmountL.textColor = WJColorMainRed;
    exchangeAmountL.font = WJFont14;
    exchangeAmountL.backgroundColor = [UIColor clearColor];
    [bgView addSubview:exchangeAmountL];
    
    
//    UILabel *consumedL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), exchangeL.bottom, ALD(80), ALD(20))];
//    consumedL.text = @"获得积分";
//    consumedL.textColor = WJColorNavigationBar;
//    consumedL.backgroundColor = [UIColor clearColor];
//    consumedL.font = WJFont12;
//    [bgView addSubview:consumedL];
//    
//    UILabel *consumedAmountL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(10) - ALD(80), consumedL.frame.origin.y, ALD(80), ALD(20))];
//    consumedAmountL.text = self.totleIntegral;
//    consumedAmountL.textAlignment = NSTextAlignmentRight;
//    consumedAmountL.textColor = WJColorNavigationBar;
//    consumedAmountL.font = WJFont12;
//    consumedAmountL.backgroundColor = [UIColor clearColor];
//    [bgView addSubview:consumedAmountL];
    
    
    UIButton *backHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backHomeButton.frame = CGRectMake(ALD(56), exchangeAmountL.bottom+ALD(20), ALD(117), ALD(35));
    [backHomeButton setTitle:@"回首页" forState:UIControlStateNormal];
    [backHomeButton setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
    backHomeButton.layer.cornerRadius = 4;
    backHomeButton.layer.borderColor = WJColorDardGray9.CGColor;
    backHomeButton.layer.borderWidth = 0.5;
    backHomeButton.titleLabel.font = WJFont14;
    [backHomeButton addTarget:self action:@selector(backHomeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backHomeButton];
    
    UIButton *checkOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkOrderButton.frame = CGRectMake(kScreenWidth-ALD(117)-ALD(56), backHomeButton.y, ALD(117), ALD(35));
    [checkOrderButton setTitle:@"查看订单" forState:UIControlStateNormal];
    [checkOrderButton setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
    checkOrderButton.layer.cornerRadius = 4;
    checkOrderButton.layer.borderColor = WJColorDardGray9.CGColor;
    checkOrderButton.layer.borderWidth = 0.5;
    checkOrderButton.titleLabel.font = WJFont14;
    [checkOrderButton addTarget:self action:@selector(checkOrderButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:checkOrderButton];
    
}

#pragma mark - Action
-(void)backHomeButtonAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.tabBarController.selectedIndex != 0) {
        
        [appDelegate.tabBarController changeTabIndex:0];
    }
}

- (void)backBarButton:(UIButton *)btn
{
    WJViewController *vc = [[WJGlobalVariable sharedInstance] payfromController];
    
    if ([vc isKindOfClass:[WJMyOrderController class]]) {
        
        [self.navigationController popToViewController:vc animated:NO];
        
    } else if ([vc isKindOfClass:[WJOrderDetailController class]]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccessRefresh" object:nil];
        
        [self.navigationController popToViewController:vc animated:NO];
        
    } else if ([vc isKindOfClass:[WJProductDetailController class]]) {
        
        [self.navigationController popToViewController:vc animated:NO];

        
    } else if ([vc isKindOfClass:[WJShoppingCartViewController class]]) {
        
        [self.navigationController popToViewController:vc animated:NO];
        
    }
}


-(void)checkOrderButtonAction
{
//    WJViewController *vc = [[WJGlobalVariable sharedInstance] payfromController];
//    
//    if ([vc isKindOfClass:[WJMyOrderController class]]) {
//        
//        [self.navigationController popToViewController:vc animated:NO];
//        
//    }  else if ([vc isKindOfClass:[WJOrderDetailController class]]) {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccessRefresh" object:nil];
//        
//        [self.navigationController popToViewController:vc animated:NO];
//        
//    }
    
    WJMyOrderController *myOrderVC = [[WJMyOrderController alloc] init];
    [self.navigationController pushViewController:myOrderVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
