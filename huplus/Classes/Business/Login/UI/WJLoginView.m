//
//  WJLoginView.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJLoginView.h"


#define countTimeDown   60
@interface WJLoginView()<UITextFieldDelegate>
{
    UIView      * backgroundView;
    UILabel     * phoneLabel;
    UILabel     * verifyLabel;
    UIView      * line;
    UIView      * bottomLine;
    
    NSInteger     timeCount;
}

@end

@implementation WJLoginView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addLoginUI];
    }
    return self;
}

#pragma mark - Cusitom Function

- (void)addLoginUI
{
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(88)+1)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgroundView];
    
    CGFloat phoneLabelWidth = [UILabel getWidthWithTitle:@"手机号" font:WJFont15];
    phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), 0, phoneLabelWidth, ALD(44))];
    phoneLabel.font = WJFont15;
    phoneLabel.textColor = WJColorLoginTitle;
    phoneLabel.text = @"手机号";
    [self addSubview:phoneLabel];
    
    [self addSubview:self.phoneTextField];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(ALD(15), phoneLabel.bottom, kScreenWidth - ALD(15), 0.5)];
    line.backgroundColor = WJColorSeparatorLine;
    [self addSubview:line];
    
    verifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), line.bottom, phoneLabelWidth, ALD(44))];
    verifyLabel.font = WJFont15;
    verifyLabel.textColor = WJColorLoginTitle;
    verifyLabel.text = @"验证码";
    [self addSubview:verifyLabel];
    
    [self addSubview:self.verifyTextField];
    [self addSubview:self.getVerifyCodeBtn];
    
    bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, _verifyTextField.bottom, kScreenWidth, 0.5)];
    bottomLine.backgroundColor = WJColorSeparatorLine;
    [self addSubview:bottomLine];
    
    [self addSubview:self.loginBtn];
    
//    [self addSubview:self.changeBtn];
    
    [self.phoneTextField becomeFirstResponder];
    timeCount = countTimeDown;
}


- (void)allTFResignFirstResponder
{
    [self.phoneTextField resignFirstResponder];
    [self.verifyTextField resignFirstResponder];
}


#pragma mark - 倒计时功能

- (void)startTimer{
    [self.getVerifyCodeBtn setTitle:@"60秒" forState:UIControlStateNormal];
    self.getVerifyCodeBtn.enabled = NO;
    [self.verifyTimer invalidate];
    self.verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBtnTitle) userInfo:nil repeats:YES];
    [_verifyTimer fire];
}

- (void)changeBtnTitle{
    
    if (timeCount <= 0) {
        timeCount = 60;
        [self.verifyTimer invalidate];
        _verifyTimer = nil;
        [self.getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getVerifyCodeBtn.enabled = YES;
        return;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
                [self.getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"%@秒", @(timeCount--)] forState:UIControlStateNormal];
        });
    }
    
}

#pragma mark - Button Action
- (void)getVerifyAction
{
    //验证手机号
    if([WJUtilityMethod isValidatePhone:self.phoneTextField.text]) {
//        验证码请求
        self.getVerifyCodeBlock();
        [self startTimer];
        self.verifyTextField.text = @"";
        [self.verifyTextField becomeFirstResponder];
    }else {
        if(self.phoneTextField.text.length <= 0){
            ALERT(@"请输入正确手机号");
        }else{
            ALERT(@"请输入正确格式的验证码");
        }
    }
}

//- (void)loginAction
//{
//    [self allTFResignFirstResponder];
//    
//    if (![WJUtilityMethod isValidatePhone:self.phoneTextField.text] ) {
//        ALERT(@"请输入正确手机号");
//        return;
//    }
//    if (self.verifyTextField.text.length != 4) {
//        ALERT(@"请输入正确格式的验证码");
//        return;
//    }
//    
////ToDo:跳转控制器
//}
//
//- (void)changePhoneAction
//{
//    if (![WJUtilityMethod isValidatePhone:self.phoneTextField.text]) {
//        ALERT(@"请输入正确手机号");
//        return;
//    }
//    if (![WJUtilityMethod isValidateVerifyCode:self.verifyTextField.text]) {
//        ALERT(@"请输入正确格式的验证码");
//        return;
//    }
//    
//    //ToDo:跳转跟换手机号码
//}



#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.loginBtn.enabled = NO;
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phoneTextField) {
        if ([string length] > 0) {
            if (textField.text.length >= 11) {
//                [self.verifyTextField becomeFirstResponder];
                return NO;
            }
        }
    }
    
    if (textField == self.verifyTextField) {
        if ([string length] > 0) {
            if (textField.text.length >= 6) {
                return NO;
            }
        }
    }
    
    if (string.length > 0 ) {
        if (self.phoneTextField.text.length >0 && self.verifyTextField.text.length > 0) {
            self.loginBtn.enabled = YES;
        }
    }else{
        if (textField.text.length <= 1) {
            if (self.phoneTextField.text.length <= 11 && self.verifyTextField.text.length <= 1) {
                self.loginBtn.enabled = NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - Setter And Getter

- (UITextField *)phoneTextField
{
    if (_phoneTextField == nil) {
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(phoneLabel.right+ALD(15), 0, kScreenWidth - ALD(45) - phoneLabel.width, ALD(44))];
        _phoneTextField.font = WJFont15;
        _phoneTextField.textColor = WJColorLoginTitle;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;//无小数点
        _phoneTextField.placeholder = @"请输入您的手机号";
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.delegate = self;
    }
    return _phoneTextField;
}


- (UITextField *)verifyTextField
{
    if (_verifyTextField == nil) {
        _verifyTextField = [[UITextField alloc] initWithFrame:CGRectMake(verifyLabel.right+ALD(15), line.bottom, SCREEN_WIDTH - ALD(140)-verifyLabel.width, ALD(44))];
        _verifyTextField.font = WJFont15;
        _verifyTextField.keyboardType = UIKeyboardTypeNumberPad;
        _verifyTextField.placeholder = @"请输入您的验证码";
        _verifyTextField.textColor = WJColorLoginTitle;
        _verifyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _verifyTextField.delegate = self;
    }
    return _verifyTextField;
}

- (UIButton *)getVerifyCodeBtn
{
    if (_getVerifyCodeBtn == nil) {
        _getVerifyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getVerifyCodeBtn.frame = CGRectMake(kScreenWidth - ALD(95), _verifyTextField.centerY - ALD(15), ALD(80), ALD(30));
        [_getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getVerifyCodeBtn setTitleColor:WJColorMainRed forState:UIControlStateNormal];
        _getVerifyCodeBtn.titleLabel.font = WJFont12;
        _getVerifyCodeBtn.layer.cornerRadius = 4;
        _getVerifyCodeBtn.layer.borderColor = [WJColorMainRed CGColor];
        _getVerifyCodeBtn.layer.borderWidth = 0.5;
    }
    return _getVerifyCodeBtn;
}

- (UIButton *)loginBtn
{
    if (_loginBtn == nil) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setFrame:CGRectMake(ALD(15), ALD(30) + bottomLine.bottom, kScreenWidth - ALD(30), ALD(44))];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:WJColorWhite forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:WJFont15];
        [_loginBtn setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorViewNotEditable] forState:UIControlStateDisabled];
        [_loginBtn setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorMainRed] forState:UIControlStateNormal];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.enabled = NO;
        _loginBtn.adjustsImageWhenHighlighted = NO;
    }
    return _loginBtn;
}

- (UIButton *)changeBtn
{
    if (_changeBtn == nil) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setFrame:CGRectMake(kScreenWidth - 100 - ALD(15), ALD(15) + _loginBtn.bottom, 100, ALD(20))];
        [_changeBtn setBackgroundColor:[UIColor clearColor]];
        [_changeBtn setTitle:@"更换原手机号" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [_changeBtn setImage:[UIImage imageNamed:@"login_close_iocn"] forState:UIControlStateNormal];
        [_changeBtn.titleLabel setFont:WJFont12];
        [_changeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        _changeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 100 - 7, 0, 0);
        _changeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 7+5);

    }
    return _changeBtn;
}


@end
