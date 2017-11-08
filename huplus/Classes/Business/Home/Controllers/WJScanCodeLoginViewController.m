//
//  WJScanCodeLoginViewController.m
//  HuPlus
//
//  Created by reborn on 17/1/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJScanCodeLoginViewController.h"
#import "WJLoginController.h"
#import "AFNetworking.h"

@interface WJScanCodeLoginViewController ()

@end

@implementation WJScanCodeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫码登录";
    self.isHiddenTabBar = YES;
    // Do any additional setup after loading the view.
    
    [self InitContentView];
}

-(void)InitContentView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgView.backgroundColor = WJColorViewBg;
    [self.view addSubview:bgView];
    
    UIImage *computerImage = [UIImage imageNamed:@"computer_icon"];
    UIImageView *computerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - computerImage.size.width)/2, ALD(80), computerImage.size.width, computerImage.size.height)];
    computerImageView.image = computerImage;
    [bgView addSubview:computerImageView];
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.text = @"V+电脑端登录确认";
    titleL.font = WJFont14;
    titleL.textColor = WJColorNavigationBar;
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize txtSize = [titleL.text sizeWithAttributes:@{NSFontAttributeName:WJFont14} constrainedToSize:CGSizeMake(1000000, ALD(30))];
    titleL.frame = CGRectMake((kScreenWidth - txtSize.width)/2, computerImageView.bottom + ALD(30), txtSize.width, ALD(30));
    [bgView addSubview:titleL];
    
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(ALD(15), titleL.bottom + ALD(100), kScreenWidth - ALD(30), ALD(40));
    [confirmButton setTitle:@"确认登录" forState:UIControlStateNormal];
    [confirmButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    confirmButton.layer.cornerRadius = 4;
    confirmButton.layer.borderColor = WJColorNavigationBar.CGColor;
    confirmButton.titleLabel.font = WJFont14;
    confirmButton.backgroundColor = WJColorMainRed;
    [confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:confirmButton];
    
    
    UIButton *cancelLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelLoginButton.frame = CGRectMake(ALD(15), confirmButton.bottom + ALD(20), kScreenWidth - ALD(30), ALD(40));
    [cancelLoginButton setTitle:@"取消登录" forState:UIControlStateNormal];
    [cancelLoginButton setTitleColor:WJColorLightGray forState:UIControlStateNormal];
    cancelLoginButton.layer.cornerRadius = 4;
    cancelLoginButton.layer.borderColor = WJColorLightGray.CGColor;
    cancelLoginButton.layer.borderWidth = 0.5;
    cancelLoginButton.titleLabel.font = WJFont14;
    [cancelLoginButton addTarget:self action:@selector(cancelLoginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelLoginButton];
}

#pragma mark - Action
-(void)confirmButtonAction
{
    if (USER_TEL) {
        NSString *urlString = [NSString stringWithFormat:@"%@&loginName=%@",self.codeString,USER_TEL];
        //网络
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            ALERT(error.description);
        }];
    }else{
        WJLoginController *loginVC = [[WJLoginController alloc]init];
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
   
}

-(void)cancelLoginButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
