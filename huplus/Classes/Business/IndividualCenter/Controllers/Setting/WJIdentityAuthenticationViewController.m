//
//  WJIdentityAuthenticationViewController.m
//  HuPlus
//
//  Created by reborn on 17/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJIdentityAuthenticationViewController.h"
#import "WJIdentityAuthenticationView.h"
#import "WJChangePayPasswordController.h"
@interface WJIdentityAuthenticationViewController ()

@property(nonatomic,strong)WJIdentityAuthenticationView      *identityAuthenticationView;

@end

@implementation WJIdentityAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份认证";
    self.isHiddenTabBar = YES;
    self.view.backgroundColor = WJColorViewBg;
    [self.view addSubview:self.identityAuthenticationView];
    
}

#pragma mark - Cusitom Function

- (void)goOut
{
    [_identityAuthenticationView.verifyTimer invalidate];
    _identityAuthenticationView.verifyTimer = nil;
    [_identityAuthenticationView.phoneTextField resignFirstResponder];
    [_identityAuthenticationView.verifyTextField resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationSetUp
{
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton.titleLabel setFont:WJFont14];
    [cancelButton setFrame:CGRectMake(0, 0, 40, 30)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(goOut) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = cancelItem;
}

#pragma mark - Button Action
- (void)nextBtnAction
{
    WJChangePayPasswordController *changePayPasswordVC = [[WJChangePayPasswordController alloc] initWithPsdType:ChangePayPsdTypeNew];
    [self.navigationController pushViewController:changePayPasswordVC animated:YES];
    
}


#pragma mark - Setter And Getter
- (WJIdentityAuthenticationView *)identityAuthenticationView
{
    if (_identityAuthenticationView == nil) {
        _identityAuthenticationView = [[WJIdentityAuthenticationView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_identityAuthenticationView.nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _identityAuthenticationView.getVerifyCodeBlock = ^(){
            //验证码网络请求；
            
        };
    }
    return _identityAuthenticationView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
