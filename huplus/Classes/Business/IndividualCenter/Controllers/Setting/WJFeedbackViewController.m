//
//  WJFeedbackViewController.m
//  CardsBusiness
//
//  Created by XT Xiong on 16/1/7.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJFeedbackViewController.h"
#import "XTTextView.h"
#import "APIFeedbackManager.h"
//#import "CBScanClient.h"

@interface WJFeedbackViewController ()<UITextViewDelegate,APIManagerCallBackDelegate>

@property(nonatomic,strong) UIView              * backgroundView;
@property(nonatomic,strong) UIView              * lineView;
@property(nonatomic,strong) XTTextView          * feedbackTF;
@property(nonatomic,strong) UIButton            * sureBtn;

@property(nonatomic,strong) APIFeedbackManager  * feedBackManager;

@end

@implementation WJFeedbackViewController

#pragma mark- Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.isHiddenTabBar = YES;
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.feedbackTF];
    [self.view addSubview:self.sureBtn];
    [self.view addSubview:self.lineView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"%@",manager.errorMessage);
    [self showCustomDialog];
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    ALERT(manager.errorMessage);
}



#pragma mark - UIButton Action
- (void)sureBtnAction
{
    if ([WJUtilityMethod isNotReachable]) {
        NSString * string  = [self.feedbackTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        if ([text isEqualToString:@""])
        {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入您的宝贵意见"];
            return;
        }

        self.feedBackManager.contentStr = text;
        [self.feedBackManager loadData];
    }else{
        ALERT(@"反馈失败，请检查网络");
    }
    
}

- (void)showCustomDialog
{
    [_adviceProgressButton removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"提交成功！"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.feedbackTF resignFirstResponder];
}


#pragma mark- Getter and Setter

- (APIFeedbackManager *)feedBackManager
{
    if (_feedBackManager == nil) {
        _feedBackManager = [[APIFeedbackManager alloc] init];
        _feedBackManager.delegate = self;
        _feedBackManager.userId = USER_ID?:@"";
    }
    return _feedBackManager;
}

- (UIView *)backgroundView
{
    if (nil == _backgroundView) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.frame = CGRectMake(0, 1, kScreenWidth, ALD(150));
        _backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundView;
}

- (UIView *)lineView
{
    if (nil == _lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.frame = CGRectMake(0, 1, kScreenWidth, 2);
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}


- (XTTextView *)feedbackTF
{
    if (nil == _feedbackTF) {
        _feedbackTF = [[XTTextView alloc]init];
        _feedbackTF.frame = CGRectMake(ALD(13), ALD(2), kScreenWidth - ALD(13), ALD(148));
        _feedbackTF.font = WJFont14;
        _feedbackTF.placeholder = @"我们期待听到你的声音，请简要描述你的问题和意见！";
        _feedbackTF.placeholderTextColor = WJColorDardGray9;
        _feedbackTF.delegate = self;
    }
    return _feedbackTF;
}

- (UIButton *)sureBtn
{
    if (nil == _sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake((kScreenWidth - ALD(345))/2, ALD(200), ALD(345), ALD(48));
        [_sureBtn setTitle:@"提交" forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = ALD(24);
        _sureBtn.enabled = YES;
        [_sureBtn setBackgroundColor:WJColorMainRed];
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (MBProgressHUD*) adviceProgressButton
{
    if(!_adviceProgressButton)
    {
        _adviceProgressButton=[[MBProgressHUD alloc]init];
        _adviceProgressButton.mode=MBProgressHUDModeCustomView;
        _adviceProgressButton.labelText = @"操作成功";
        _adviceProgressButton.customView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checkmark" ]];
    }
    return _adviceProgressButton;
}

@end
