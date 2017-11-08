//
//  WJChangeNickNameViewController.m
//  HuPlus
//
//  Created by reborn on 17/1/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJChangeNickNameViewController.h"

@interface WJChangeNickNameViewController ()<UITextFieldDelegate>
{
    UITextField *nameTF;
}
@end

@implementation WJChangeNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    self.isHiddenTabBar = YES;
    // Do any additional setup after loading the view.
    [self initView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressGesture)];
    [self.view  addGestureRecognizer:tapGesture];
}

-(void)initView
{
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(44))];
    nameTF.delegate = self;
    nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTF.text = self.nickName;
    nameTF.returnKeyType = UIReturnKeyDone;
    nameTF.layer.borderWidth = 0.5;
    nameTF.layer.borderColor = WJColorSeparatorLine.CGColor;
    nameTF.backgroundColor = WJColorWhite;
    [self.view addSubview:nameTF];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ALD(10), ALD(44))];
    nameTF.leftView = leftView;
    nameTF.leftViewMode = UITextFieldViewModeAlways;

    
    UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), nameTF.bottom + ALD(5), ALD(kScreenWidth - ALD(24)), ALD(20))];
    tipL.text = @"可由1-20个字符组成";
    tipL.font = WJFont12;
    tipL.textColor = WJColorDardGray9;
    tipL.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipL];
    
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(ALD(20), tipL.bottom + ALD(20), kScreenWidth - ALD(40), ALD(40));
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    confirmButton.backgroundColor = WJColorMainRed;
    confirmButton.layer.cornerRadius = 4;
    confirmButton.layer.masksToBounds = YES;
    confirmButton.titleLabel.font = WJFont14;
    [confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmButton];
    
}

#pragma mark - Action
-(void)confirmButtonAction
{
    int nameLength = [self convertToInt:nameTF.text];
    if (nameLength > 1 && nameLength < 21) {
        if (_nickNameBlock) {
            self.nickNameBlock(nameTF.text);
        }
        [nameTF resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        ALERT(@"请输入正确的昵称");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

#pragma mark -event
-(void)handletapPressGesture
{
    [nameTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
