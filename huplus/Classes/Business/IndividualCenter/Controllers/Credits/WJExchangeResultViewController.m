//
//  WJExchangeResultViewController.m
//  HuPlus
//
//  Created by reborn on 16/12/23.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJExchangeResultViewController.h"

@interface WJExchangeResultViewController ()

@end

@implementation WJExchangeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑换成功";
    self.isHiddenTabBar = YES;
    [self UISetUp];
}

-(void)UISetUp
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(220))];
    bgView.backgroundColor = WJColorWhite;
    [self.view addSubview:bgView];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.width - ALD(30))/2, ALD(50), ALD(30), ALD(30))];
    imageView.backgroundColor = WJRandomColor;
    [bgView addSubview:imageView];
    
    UILabel *exchangeDesL = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - ALD(80))/2, imageView.bottom + ALD(10), ALD(80), ALD(20))];
    exchangeDesL.text = @"兑换成功";
    exchangeDesL.textAlignment = NSTextAlignmentCenter;
    exchangeDesL.font = WJFont15;
    exchangeDesL.backgroundColor = [UIColor clearColor];
    [bgView addSubview:exchangeDesL];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), exchangeDesL.bottom + ALD(20), kScreenWidth - ALD(24), 1)];
    lineView.backgroundColor = WJColorSeparatorLine;
    [bgView addSubview:lineView];
    
    UILabel *exchangeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), lineView.bottom + ALD(10), ALD(80), ALD(20))];
    exchangeL.text = @"兑换金额";
    exchangeL.textColor = WJColorNavigationBar;
    exchangeL.font = WJFont12;
    exchangeL.backgroundColor = [UIColor clearColor];
    [bgView addSubview:exchangeL];
    
    UILabel *exchangeAmountL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(10) - ALD(80), exchangeL.frame.origin.y, ALD(80), ALD(20))];
    exchangeAmountL.text = @"￥2000.00";
    exchangeAmountL.textAlignment = NSTextAlignmentRight;
    exchangeAmountL.textColor = WJColorNavigationBar;
    exchangeAmountL.font = WJFont12;
    exchangeAmountL.backgroundColor = [UIColor clearColor];
    [bgView addSubview:exchangeAmountL];
    
    
    UILabel *consumedL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), exchangeL.bottom, ALD(80), ALD(20))];
    consumedL.text = @"花费积分";
    consumedL.textColor = WJColorNavigationBar;
    consumedL.backgroundColor = [UIColor clearColor];
    consumedL.font = WJFont12;
    [bgView addSubview:consumedL];
    
    UILabel *consumedAmountL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(10) - ALD(80), consumedL.frame.origin.y, ALD(80), ALD(20))];
    consumedAmountL.text = @"2000.00";
    consumedAmountL.textAlignment = NSTextAlignmentRight;
    consumedAmountL.textColor = WJColorNavigationBar;
    consumedAmountL.font = WJFont12;
    consumedAmountL.backgroundColor = [UIColor clearColor];
    [bgView addSubview:consumedAmountL];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
