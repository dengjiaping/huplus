//
//  WJIdentityAuthenticationView.m
//  HuPlus
//
//  Created by reborn on 17/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJIdentityAuthenticationView.h"
#define countTimeDown   60

@interface WJIdentityAuthenticationView ()<UITextFieldDelegate>
{
    UIView      * backgroundView;
    UILabel     * phoneLabel;
    UILabel     * verifyLabel;
    UIView      * line;
    UIView      * bottomLine;
    
    NSInteger    timeCount;
}
@end

@implementation WJIdentityAuthenticationView
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
    
    [self addSubview:self.nextBtn];
    
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
        
        if (deviceIs6P) {
            [self.getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"%@秒", @(timeCount--)] forState:UIControlStateNormal];
            
        } else {
            self.getVerifyCodeBtn.titleLabel.text = [NSString stringWithFormat:@"%@秒", @(timeCount--)];
        }
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

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.nextBtn.enabled = NO;
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phoneTextField) {
        if ([string length] > 0) {
            if (textField.text.length >= 11) {
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
            self.nextBtn.enabled = YES;
        }
    }else{
        if (textField.text.length <= 1) {
            if (self.phoneTextField.text.length <= 11 && self.verifyTextField.text.length <= 1) {
                self.nextBtn.enabled = NO;
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
        [_getVerifyCodeBtn setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        _getVerifyCodeBtn.titleLabel.font = WJFont12;
        _getVerifyCodeBtn.layer.cornerRadius = 4;
        _getVerifyCodeBtn.layer.borderColor = [WJColorNavigationBar CGColor];
        _getVerifyCodeBtn.layer.borderWidth = 0.5;
        [_getVerifyCodeBtn addTarget:self action:@selector(getVerifyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getVerifyCodeBtn;
}

- (UIButton *)nextBtn
{
    if (_nextBtn == nil) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setFrame:CGRectMake(ALD(15), ALD(30) + bottomLine.bottom, kScreenWidth - ALD(30), ALD(44))];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:WJColorWhite forState:UIControlStateNormal];
        [_nextBtn.titleLabel setFont:WJFont15];
        [_nextBtn setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorViewNotEditable] forState:UIControlStateDisabled];
        [_nextBtn setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorNavigationBar] forState:UIControlStateNormal];
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = 4;
        _nextBtn.enabled = NO;
        _nextBtn.adjustsImageWhenHighlighted = NO;
    }
    return _nextBtn;
}


@end
