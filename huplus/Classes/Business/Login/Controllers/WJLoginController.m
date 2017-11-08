//
//  WJLoginController.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJLoginController.h"
#import "WJLoginView.h"
#import "APIVerificationCodeManager.h"
#import "APILoginManager.h"
#import "WJLoginReformer.h"
#import "WJPushManager.h"
#import "WJTabBarController.h"

@interface WJLoginController ()<APIManagerCallBackDelegate>

@property(nonatomic,strong)WJLoginView                  * loginView;
@property(nonatomic,strong)APIVerificationCodeManager   * verificationManager;
@property(nonatomic,strong)APILoginManager              * loginManager;

@end

@implementation WJLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.isPresentVC = YES;
    [self hiddenBackBarButtonItem];
    [self removeScreenEdgePanGesture];

    [self navigationSetUp];
    [self.view addSubview:self.loginView];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"%@",manager.errorMessage);
    if([manager isKindOfClass:[APILoginManager class]])
    {
        NSDictionary *userDic = [manager fetchDataWithReformer:[[WJLoginReformer alloc]init]];
        if (userDic) {
            [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:KUserInformation];
            NSDictionary  *userInformation = [[NSUserDefaults standardUserDefaults] dictionaryForKey:KUserInformation];
            NSLog(@"%@",userInformation);
            [self dismissViewControllerAnimated:YES completion:nil];
            [self successGoOut];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginRefreshHead" object:nil];

        }
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"%@",manager.errorMessage);
    ALERT(manager.errorMessage);
}


#pragma mark - Cusitom Function

- (void)navigationSetUp
{
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton.titleLabel setFont:WJFont14];
    [cancelButton setFrame:CGRectMake(0, 0, 40, 30)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(goOut) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = cancelItem;
}

- (void)successGoOut
{
    switch (self.loginFrom) {
        case LoginFromTabCustom:
            [[NSNotificationCenter defaultCenter] postNotificationName:kTabCustomVCResponse object:nil];
            break;
        case LoginFromWebToUserId:
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserIdToWeb object:nil];

            break;
            
        default:
            break;
    }
}

#pragma mark - Button Action
- (void)goOut
{
    [_loginView.verifyTimer invalidate];
    _loginView.verifyTimer = nil;
    [_loginView.phoneTextField resignFirstResponder];
    [_loginView.verifyTextField resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.loginFrom == LoginFromTabCustom) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTabCustomVCGoOutVC object:nil];
    }
}

- (void)getVerifyAction
{
    //验证手机号
    if([WJUtilityMethod isValidatePhone:self.loginView.phoneTextField.text]) {
        //验证码请求
        [self.verificationManager loadData];
        [self.loginView startTimer];
        self.loginView.verifyTextField.text = @"";
        [self.loginView.verifyTextField becomeFirstResponder];
    }else {
        if(self.loginView.phoneTextField.text.length <= 0){
            ALERT(@"请输入正确手机号");
        }else{
            ALERT(@"请输入正确格式的验证码");
        }
    }
     
}


- (void)loginAction
{
    [MobClick event:@"denglu"];
    
    [_loginView.phoneTextField resignFirstResponder];
    [_loginView.verifyTextField resignFirstResponder];
    if (![WJUtilityMethod isValidatePhone:_loginView.phoneTextField.text] ) {
        ALERT(@"请输入正确手机号");
        return;
    }
    if (_loginView.verifyTextField.text.length != 6) {
        ALERT(@"请输入正确格式的验证码");
        return;
    }
    
    //登录网络请求
    [self.loginManager loadData];

}

- (void)changePhoneAction
{
    if (![WJUtilityMethod isValidatePhone:_loginView.phoneTextField.text]) {
        ALERT(@"请输入正确手机号");
        return;
    }
    if (![WJUtilityMethod isValidateVerifyCode:_loginView.verifyTextField.text]) {
        ALERT(@"请输入正确格式的验证码");
        return;
    }
    
    //ToDo:跳转跟换手机号码
}


#pragma mark - Setter And Getter
- (WJLoginView *)loginView
{
    if (_loginView == nil) {
        _loginView = [[WJLoginView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_loginView.changeBtn addTarget:self action:@selector(changePhoneAction) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.getVerifyCodeBtn addTarget:self action:@selector(getVerifyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginView;
}

- (APIVerificationCodeManager *)verificationManager
{
    if (nil == _verificationManager) {
        _verificationManager = [[APIVerificationCodeManager alloc] init];
        _verificationManager.delegate = self;
    }
    _verificationManager.phoneNum = self.loginView.phoneTextField.text;
    return _verificationManager;
}

- (APILoginManager *)loginManager
{
    if (nil == _loginManager) {
        _loginManager = [[APILoginManager alloc] init];
        _loginManager.delegate = self;
    }
    _loginManager.phoneNum = self.loginView.phoneTextField.text;
    _loginManager.verificationCode = self.loginView.verifyTextField.text;
    _loginManager.terminal = @"0";
    _loginManager.JPushID = [WJPushManager registrationID]?:@"";
    return _loginManager;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
