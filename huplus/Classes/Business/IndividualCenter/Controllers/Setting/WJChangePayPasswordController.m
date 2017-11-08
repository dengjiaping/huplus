//
//  WJChangePayPasswordController.m
//  HuPlus
//
//  Created by reborn on 17/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJChangePayPasswordController.h"
#import "WJSystemAlertView.h"
#define IVTag  200
#define LockTime 60 * 3
#define LimiteTime 60 * 3

@interface WJChangePayPasswordController ()<UITextFieldDelegate,WJSystemAlertViewDelegate>
{
//    ResetPsyType psdResetType;
    
    UIView *enterBg;
    
    UIButton *nextButton;
    
    NSInteger selectedIvTag;
    NSString *enterPassword;
    
    NSMutableDictionary *dataDic;
    NSMutableArray *enterPsdViews;
}
@end

@implementation WJChangePayPasswordController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (instancetype)initWithPsdType:(ChangePayPsdType)psdType
                      {
    if (self = [super init]) {
        enterPsdType = psdType;
    }
    return self;
}

- (void)changeInputState
{
    for (UIImageView *iv in enterPsdViews) {
        iv.highlighted = NO;
    }
    [psdArray removeAllObjects];
    self.canInputPassword = YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showKeyBoard];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self removeScreenEdgePanGesture];
    self.isHiddenTabBar = YES;
    
    psdArray = [NSMutableArray arrayWithCapacity:0];

    
    NSString *filePath = [self filePatch];
    dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    if (dataDic == nil) {
        dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"errorCount",@"0",@"time", @"0",@"limiteTime",nil];
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filePath contents:nil attributes:nil];
        [dataDic writeToFile:filePath atomically:YES];
    }
    
    UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(10, ALD(55), kScreenWidth-20, ALD(36))];
    infoL.text = @"";
    infoL.textColor = WJColorDardGray3;
    infoL.font = WJFont15;
    infoL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:infoL];
    
    enterBg = [[UIView alloc] initWithFrame:CGRectMake(ALD(15), ALD(95), kScreenWidth - ALD(30), ALD(45))];
    [enterBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyBoard)]];
    enterBg.layer.cornerRadius = 3;
    enterBg.clipsToBounds = YES;
    [self.view addSubview:enterBg];
    
    
    enterPsdViews = [NSMutableArray array];
    int ivWidth = enterBg.width/6;
    for (int i = 0; i < 6; i++) {
        UIView *iconBg = [[UIView alloc] initWithFrame:CGRectMake(ivWidth*i, 0, ivWidth-1, enterBg.height)];
        iconBg.backgroundColor = WJColorWhite;
        iconBg.layer.shadowColor = WJColorViewBg.CGColor;
        iconBg.layer.shadowOffset = CGSizeMake(1, 0);
        iconBg.layer.shadowOpacity = 0;
        iconBg.layer.shadowRadius = 0.5;
        [enterBg addSubview:iconBg];
        
        UIImage *normal = [WJUtilityMethod imageFromColor:[UIColor whiteColor] Width:20 Height:20];
        
        UIImage *hight = [WJUtilityMethod imageFromColor:WJColorNavigationBar Width:20 Height:20];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:normal highlightedImage:hight];
        iv.frame = CGRectMake(0, 0, 20, 20);
        iv.center = CGPointMake(iconBg.width/2, iconBg.height/2);
        iv.layer.cornerRadius = 10;
        iv.layer.masksToBounds = YES;
        iv.tag = IVTag+i;
        [iconBg addSubview:iv];
        [enterPsdViews addObject:iv];
    }
    selectedIvTag = IVTag;
    CGRect frame = enterBg.frame;
    frame.size.width = ivWidth*6-1;
    enterBg.frame = frame;
    
    enterBg.centerX = self.view.centerX;
    
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(ALD(20), enterBg.bottom + ALD(30), kScreenWidth - ALD(40), ALD(40));
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    nextButton.backgroundColor = WJColorNavigationBar;
    nextButton.titleLabel.font = WJFont14;
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    NSString *title = nil;
    switch (enterPsdType) {
        case ChangePayPsdTypeVerify:{
            title = @"支付密码验证";
            infoL.text = @"请输入支付密码，以验证身份";
            [nextButton setTitle:@"确定" forState:UIControlStateNormal];

        }
            break;
        case ChangePayPsdTypeNew:{
            title = @"设置支付密码";
            infoL.text = @"请设置6位数字支付密码";
            [nextButton setTitle:@"下一步" forState:UIControlStateNormal];

        }
            break;
        case ChangePayPsdTypeConfirm:{
            infoL.hidden = NO;
            title = @"确认支付密码";
            infoL.text = @"请再次输入已确认";
            [nextButton setTitle:@"确定" forState:UIControlStateNormal];

        }
            break;
            
        default:
//            title = @"请输入旧密码";
            break;
    }
    self.title = title;
    
    tf = [[UITextField alloc] initWithFrame:CGRectMake(-100, 0, 103, 20)];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.delegate = self;
    tf.alpha = 0;
    [self.view addSubview:tf];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [tf resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self changeInputState];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.canInputPassword) {
        if (string.length == 0) {
            if (selectedIvTag > IVTag) {
                selectedIvTag -= 1;
                UIImageView *iv = (UIImageView *)[self.view viewWithTag:selectedIvTag];
                iv.highlighted = NO;
                [psdArray removeLastObject];
            }
        }else{
            if (selectedIvTag < 206) {
                UIImageView *iv = (UIImageView *)[self.view viewWithTag:selectedIvTag];
                iv.highlighted = YES;
                selectedIvTag += 1;
                [psdArray addObject:string];
                
//                if (selectedIvTag == 206) {
//                    
//                    [self performSelector:@selector(startSureBtnAction) withObject:nil afterDelay:0.3];
//                }
            }
        }
    }
    
    return self.canInputPassword;
}


- (void)cleanPsdView{
    for (UIImageView *iv in enterPsdViews) {
        iv.highlighted = NO;
    }
    
    selectedIvTag = IVTag;
}

- (void)showKeyBoard{
    [tf becomeFirstResponder];
}

-(void)hideKeyBoard
{
    [tf resignFirstResponder];
}


#pragma mark - Action
-(void)nextButtonAction
{
    [self  hideKeyBoard];
    [self startSureBtnAction];
}

- (void)startSureBtnAction{
    self.canInputPassword = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sureBtnAction];
    });
}

- (void)sureBtnAction{
    
    enterPassword = [psdArray componentsJoinedByString:@""];
    
    if (psdArray.count == 0){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"密码位数不能为空"];
        self.canInputPassword = YES;
        return;
    }
    if (psdArray.count < 6) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"密码位数为6位"];
        self.canInputPassword = YES;
        return;
    }
    
    [self cleanPsdView];
    
    if (enterPsdType == ChangePayPsdTypeConfirm &&
        ![enterPassword isEqualToString:self.oldPassword]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"两次密码输入不正确！"];
        [psdArray removeAllObjects];
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    
    WJChangePayPasswordController *vc = nil;
    if (enterPsdType == ChangePayPsdTypeVerify){
        if(![WJUtilityMethod isNotReachable] && self.from == ComeFromPayCode){
            //无网
            NSString *filePath = [self filePatch];
            
            int faileNumber = [[dataDic objectForKey:@"errorCount"] intValue];
            NSInteger lastTime = [[dataDic objectForKey:@"time"] intValue];
            NSInteger distanceTime = [self distanceTimeWithBeforeTime:lastTime];
            
            NSInteger FirstErrorTime = [[dataDic objectForKey:@"limiteTime"] intValue];
            NSInteger disTime = [self distanceTimeWithBeforeTime:FirstErrorTime];
            
            //如果锁了
            if (lastTime) {
                if (distanceTime/60 >= LockTime){
                    faileNumber = 0;
                    [dataDic setObject:[NSString stringWithFormat:@"%ld",(long)faileNumber] forKey:@"errorCount"];
                    [dataDic setObject:@"0" forKey:@"time"];
                    [dataDic setObject:@"0" forKey:@"lockTime"];
                    [dataDic writeToFile:filePath atomically:YES];
                }
                
            }else{
                
                if (disTime/60 >= LimiteTime) {
                    faileNumber = 0;
                    [dataDic setObject:[NSString stringWithFormat:@"%ld",(long)faileNumber] forKey:@"errorCount"];
                    [dataDic setObject:@"0" forKey:@"time"];
                    [dataDic setObject:@"0" forKey:@"lockTime"];
                    [dataDic writeToFile:filePath atomically:YES];
                }
            }
            
            if(faileNumber >= 4){
                
                [self showAlertViewAndDistanceTime:distanceTime];
                [psdArray removeAllObjects];
                self.canInputPassword = YES;
                
                if (faileNumber == 4) {
                    [dataDic setObject:[NSString stringWithFormat:@"%@",@(++faileNumber)] forKey:@"errorCount"];
                    NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                    [dataDic setObject:nowTime forKey:@"time"];
                    [dataDic writeToFile:[self filePatch] atomically:YES];
                }
            }else{
//                WJModelPerson *person = [WJDBPersonManager getDefaultPerson];
//                
//                if (person.payPsdSalt.length > 0) {
//                    NSString *key = person.payPsdSalt;
//                    NSString *input = [enterPassword stringByAppendingString:key];
//                    if ( person.payPassword.length > 0 ) {
//                        if ([person.payPassword isEqualToString:[input getSha1String]]) {
//                            NSLog(@"支付密码本地验证通过");
//                            
//                            APIVerifyPayPwdManager *mg = [[APIVerifyPayPwdManager alloc]init];
//                            [self managerCallAPIDidSuccess:mg];
//                            
//                        }else{
//                            
//                            [dataDic setObject:[NSString stringWithFormat:@"%@",@(++faileNumber)] forKey:@"errorCount"];
//                            NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
//                            [dataDic setObject:nowTime forKey:@"time"];
//                            //记录第一次错误的时间
//                            if(faileNumber == 1){
//                                [dataDic setObject:nowTime forKey:@"limiteTime"];
//                            }
//                            [dataDic writeToFile:[self filePatch] atomically:YES];
//                            
//                            WJSystemAlertView  *alert = [[WJSystemAlertView alloc]initWithTitle:nil
//                                                                           message:[NSString stringWithFormat:@"支付密码错误！您还有%d次验证机会",(5-faileNumber)]
//                                                                          delegate:self
//                                                                 cancelButtonTitle:@"取消"
//                                                                 otherButtonTitles:@"找回支付密码"
//                                                                     textAlignment:NSTextAlignmentCenter];
//                            [alert showIn];
//                            
//                            [psdArray removeAllObjects];
//                            self.canInputPassword = YES;
//                        }
//                        
//                    }else{
//                        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请连接网络验证支付密码"];
//                    }
//                }
                
            }
            
        }else{
            
//            WJModelPerson *person = [WJDBPersonManager getDefaultPerson];
//            
//            if ([person.payPsdSalt length] > 0) {
//                NSString *input = [enterPassword stringByAppendingString:person.payPsdSalt];
//                self.verPayPsdManager.password = [input getSha1String];
//                
//                [self.verPayPsdManager loadData];
//            }else{
//                [self showLoadingView];
//                [self.salGetterManager loadData];
//                
//            }
        }
        
        
    }else if (enterPsdType == ChangePayPsdTypeNew){
        
        vc = [[WJChangePayPasswordController alloc] initWithPsdType:ChangePayPsdTypeConfirm];
        vc.oldPassword = enterPassword;
        vc.verifyCode = self.verifyCode;
        
        vc.from = self.from;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        [self requestSetPayPassword];
    }

}

#pragma mark - APIManagerCallBackDelegate

- (void)requestSetPayPassword{
    
    //请求
    if (enterPsdType == ChangePayPsdTypeNew) {
        
//        [self.changePayPsdManager loadData];

    } else if (enterPsdType == ChangePayPsdTypeVerify) {
        
    } else {
        
        //确认
    }
    
    
}

- (void)showAlertViewAndDistanceTime:(NSInteger)time
{
    NSString *messageStr;
    if ((LockTime - time/60)/60 >= 1) {
        messageStr = [NSString stringWithFormat:@"支付密码错误,输入次数过多,请%@小时后再试",@((LockTime - time/60)/60 + 1)];
    }else{
        messageStr = [NSString stringWithFormat:@"支付密码错误，输入次数过多,请%@分钟后再试",@((LockTime - time/60))];
    }
    
    WJSystemAlertView  *alert = [[WJSystemAlertView alloc]initWithTitle:nil
                                                                message:messageStr
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"找回支付密码"
                                                          textAlignment:NSTextAlignmentCenter];
    [alert showIn];
    
    
}

#pragma mark -
-(void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        self.canInputPassword = YES;
        [self showKeyBoard];
        
    } else if (buttonIndex == 1) {
        
        //找回
    }
}

#pragma mark - 存储路径和时间比较方法

- (NSInteger)distanceTimeWithBeforeTime:(NSInteger)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    NSInteger distance = now - beTime;
    return distance;
}

- (NSString *)filePatch{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
//    WJModelPerson *person = [WJDBPersonManager getDefaultPerson];
    NSString *filePatch = nil;
//    NSString *filePatch = [path stringByAppendingPathComponent:[person.userID stringByAppendingString:@"errorInformation.plist"]];
//    NSLog(@"路径：%@",filePatch);
    return filePatch;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
