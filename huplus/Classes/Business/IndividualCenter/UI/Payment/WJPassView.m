//
//  WJPassView.m
//  HuPlus
//
//  Created by reborn on 17/1/11.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJPassView.h"
#import "WJSystemAlertView.h"

#define IVTag  200
#define LockTime 60 * 3
#define LimiteTime 60 * 3

@interface WJPassView ()<UITextFieldDelegate,WJSystemAlertViewDelegate>
{
    UIView      * bgView;
    UIView      * blackView;
    UIButton    * closeButton;
    UILabel     * titleLabel;
    UIView      * topLine;
    UILabel     * conttentLabel;
    UILabel     * amountLabel;
    UIImageView * cardLogolIV;
    UILabel     * vipCardNameL;
    UIView      * middleLine;
    UIView      * bottomLine;

    UILabel     * balanceHasNumLabel;
    UIButton    * submitButton;
    UIButton    * bottomButton;
    UIImageView * tipImageView;
    UILabel     * tipLabel;
    
    UITextField    *tf;
    UIView         *enterBg;
    NSMutableArray *enterPsdViews;
    NSInteger      selectedIvTag;
    NSString       *enterPassword;
    NSMutableDictionary *dataDic;
    NSMutableArray      *psdArray;
    
}

@property (nonatomic, assign) PassViewType type;

@property (nonatomic, assign) BOOL canInputPassword;

@end

@implementation WJPassView


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title productName:(NSString *)productName
                amountNeedNum:(NSString *)amountNeedNum balanceHasNum:(NSString *)balanceHasNum passViewType:(PassViewType)passViewType
{
    if (self = [super initWithFrame:frame]) {
        self.alertTag = kPaymentPsdAlertViewTag;
        self.type = passViewType;
        UIColor * lineColor = [WJUtilityMethod colorWithHexColorString:@"d9d9d9"];
        blackView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = .4;
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(ALD(52), ALD(100), kScreenWidth -  ALD(104), kScreenWidth -  ALD(74))];
        bgView.backgroundColor = [UIColor whiteColor];
        CGFloat width = CGRectGetWidth(bgView.frame);
        
        bgView.layer.cornerRadius = 10;
        
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(ALD(16), ALD(18), ALD(14), ALD(14))];
        [closeButton setImage:[UIImage imageNamed:@"inventedcard_ic_close"] forState:UIControlStateNormal];
        [closeButton setImage:[UIImage imageNamed:@"inventedcard_ic_close_press"] forState:UIControlStateHighlighted];
        [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(30), 0, width - ALD(60), ALD(50))];
        titleLabel.font = WJFont17;
        titleLabel.textColor = WJColorDarkGray;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        topLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(50), width, 1)];
        topLine.backgroundColor = lineColor;
        
        conttentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(16), ALD(10) + CGRectGetMaxY(topLine.frame),  width - ALD(32), ALD(40))];
        conttentLabel.font = WJFont13;
        conttentLabel.textColor = WJColorDarkGray;
        conttentLabel.textAlignment = NSTextAlignmentCenter;
        conttentLabel.numberOfLines = 0;
        conttentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        amountLabel = [[UILabel alloc] init];
        amountLabel.font = WJFont32;
        amountLabel.textColor = WJColorNavigationBar;
        
        middleLine = [[UIView alloc] init];
        middleLine.backgroundColor = lineColor;
        
        cardLogolIV = [[UIImageView alloc] init];
        cardLogolIV.backgroundColor = [UIColor redColor];
        
        
        vipCardNameL = [[UILabel alloc] init];
        vipCardNameL.textColor = WJColorDarkGray;
        vipCardNameL.font = WJFont12;

        bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = lineColor;
        
        
        balanceHasNumLabel = [[UILabel alloc] init];
        balanceHasNumLabel.textColor = WJColorDarkGray;
        balanceHasNumLabel.font = WJFont12;
        
        psdArray = [NSMutableArray arrayWithCapacity:0];
        NSString *filePath = [WJGlobalVariable payPasswordVerifyFailedErrorFilePatch];
        dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        if (dataDic == nil) {
            dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"errorCount",@"0",@"time", @"0",@"limiteTime",nil];
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm createFileAtPath:filePath contents:nil attributes:nil];
            [dataDic writeToFile:filePath atomically:YES];
        }
        
        enterBg = [[UIView alloc] initWithFrame:CGRectMake(ALD(16), balanceHasNumLabel.bottom + ALD(12), width - ALD(32), ALD(40))];
        [enterBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyBoard)]];
        enterBg.backgroundColor = WJColorWhite;
        enterBg.layer.borderColor = WJColorDarkGrayLine.CGColor;
        enterBg.layer.borderWidth = 1;
        
        enterPsdViews = [NSMutableArray array];
        CGFloat gap = 1;
        CGFloat ivWidth = (enterBg.width-7*gap)/6;
        for (int i = 0; i < 6; i++) {
            
            if (i>0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake((gap+ivWidth)*i, 0, 1, enterBg.height)];
                line.backgroundColor = WJColorDarkGrayLine;
                [enterBg addSubview:line];
            }
            
            UIImage *normal = [WJUtilityMethod imageFromColor:[UIColor whiteColor] Width:16 Height:16];
            UIImage *hight = [WJUtilityMethod imageFromColor:WJColorNavigationBar Width:16 Height:16];
            
            UIImageView *iv = [[UIImageView alloc] initWithImage:normal highlightedImage:hight];
            iv.frame = CGRectMake(gap + (ivWidth-16)/2 + (gap + ivWidth)*i, (enterBg.height - 16)/2, 16, 16);
            iv.layer.cornerRadius = 8;
            iv.layer.masksToBounds = YES;
            iv.tag = IVTag+i;
            [enterBg addSubview:iv];
            [enterPsdViews addObject:iv];
        }
        
        selectedIvTag = IVTag;
        
        submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        submitButton.layer.cornerRadius = 5;
        submitButton.backgroundColor = WJColorMainRed;
        [submitButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
        
        bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomButton addTarget:self action:@selector(bottonAction) forControlEvents:UIControlEventTouchUpInside];
        bottomButton.backgroundColor = WJColorWhite;
        [bottomButton setTitleColor:WJColorMainRed forState:UIControlStateNormal];

        bottomButton.titleLabel.font = WJFont12;
        
        tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inventedcard_ic_lack"]];
        
        tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"FF635B"];
        tipLabel.font = WJFont12;
        tipLabel.text = @"余额不足";
        [tipLabel sizeToFit];
        
        tf = [[UITextField alloc] initWithFrame:CGRectMake(-100, 0, 103, 20)];
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.delegate = self;
        tf.alpha = 0;
        [self addSubview:tf];
        
        
        [bgView addSubview:closeButton];
        [bgView addSubview:titleLabel];
        [bgView addSubview:topLine];
        [bgView addSubview:conttentLabel];
        [bgView addSubview:amountLabel];
        [bgView addSubview:middleLine];
        [bgView addSubview:balanceHasNumLabel];
        [bgView addSubview:cardLogolIV];
        [bgView addSubview:vipCardNameL];
        [bgView addSubview:bottomLine];

        [bgView addSubview:enterBg];
        [bgView addSubview:submitButton];
        [bgView addSubview:bottomButton];
        [bgView addSubview:tipImageView];
        [bgView addSubview:tipLabel];
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:blackView];
        [self addSubview:bgView];
        [self addSubview:tf];
        
        [self refreshViewWithtitle:title productName:productName amountNeedNum:amountNeedNum balanceHasNum:balanceHasNum passViewType:passViewType];
    }
    return self;
}

- (void)refreshViewWithtitle:(NSString *)title
                productName:(NSString *)productName
                amountNeedNum:(NSString *)amountNeedNum
                balanceHasNum:(NSString *)balanceHasNum
                passViewType:(PassViewType)passViewType
{
    CGFloat width = CGRectGetWidth(bgView.frame);
    
    titleLabel.text = title;
    conttentLabel.text = [NSString stringWithFormat:@"%@",productName];
    
    CGSize sizeThatFits =  [conttentLabel sizeThatFits:CGSizeMake(width - ALD(32), MAXFLOAT)];
    conttentLabel.frame = CGRectMake(ALD(16), ALD(10) + CGRectGetMaxY(topLine.frame),  width - ALD(32), sizeThatFits.height);
    
    amountLabel.text = [WJUtilityMethod baoziNumberFormatter:amountNeedNum];;
    [amountLabel sizeToFit];
    amountLabel.frame = CGRectMake((width - CGRectGetWidth(amountLabel.frame))/2, conttentLabel.bottom + ALD(8),CGRectGetWidth(amountLabel.frame),CGRectGetHeight(amountLabel.frame));
    
    middleLine.frame = CGRectMake(0, ALD(8) + amountLabel.bottom, width, 1);
    
    cardLogolIV.frame = CGRectMake(ALD(12), ALD(10) + middleLine.bottom, ALD(20), ALD(20));
    
    vipCardNameL.frame = CGRectMake(cardLogolIV.right + ALD(5), CGRectGetMinY(cardLogolIV.frame), ALD(70), ALD(20));
    vipCardNameL.text = @"虎+贵宾卡";
    
    tipLabel.frame = CGRectMake(width - tipLabel.width - ALD(12), vipCardNameL.y, tipLabel.width, vipCardNameL.height);
    tipImageView.frame = CGRectMake(tipLabel.x - ALD(3) - ALD(13), tipLabel.y + (tipLabel.height - ALD(13))/2, ALD(13), ALD(13));

    bottomLine.frame = CGRectMake(0, ALD(8) + vipCardNameL.bottom, width, 1);
    
    balanceHasNumLabel.text = [NSString stringWithFormat:@"虎+贵宾卡余额：¥%@", [WJUtilityMethod  baoziNumberFormatter:[NSString stringWithFormat:@"%f",[balanceHasNum floatValue]]]];
    
    balanceHasNumLabel.frame = CGRectMake(ALD(12), bottomLine.bottom + ALD(5), width - ALD(32), ALD(30));
    
    enterBg.frame = CGRectMake(ALD(16), balanceHasNumLabel.bottom + ALD(10), width - ALD(32), ALD(40));
    
    submitButton.frame = CGRectMake (ALD(16), balanceHasNumLabel.bottom + ALD(5), width - ALD(32), ALD(40));
    
    bottomButton.frame = CGRectMake (ALD(16), submitButton.bottom + ALD(12), width - ALD(32), ALD(30));
    
    bgView.frame = CGRectMake(ALD(52), ALD(100), kScreenWidth -  ALD(104), bottomButton.bottom + ALD(16));
    
    
    switch (passViewType) {
        case PassViewTypeSubmit:
        {
            [self tipHidden];
            enterBg.hidden = YES;
            submitButton.hidden = NO;
            [submitButton setTitle:@"确认支付" forState:UIControlStateNormal];
            [bottomButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        }
            break;
        case PassViewTypeSubmitTip:
        {
            [self tipShow];
            enterBg.hidden = YES;
            submitButton.hidden = NO;
            [submitButton setTitle:@"立即充值" forState:UIControlStateNormal];
            [bottomButton setTitle:@"取消" forState:UIControlStateNormal];
        }
            break;
        case PassViewTypeInputPassword:
        {
            [self tipHidden];
            enterBg.hidden = NO;
            submitButton.hidden = YES;
            [bottomButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
            [self showKeyBoard];
            [self changeInputState];
        }
            break;
        default:
            break;
    }
    bgView.frame = CGRectMake(ALD(52), ALD(100), kScreenWidth -  ALD(104), bottomButton.bottom + ALD(6));
}

- (void)showIn
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.alpha = 0;
    self.frame = window.bounds;
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1;
    }];
    self.tag = self.alertTag;
    [window addSubview:self];
}


- (void)dismiss
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *alertView = [window viewWithTag:self.alertTag];
    [UIView animateWithDuration:0.16f animations:^{
        alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [alertView removeFromSuperview];
    }];
    
}


- (void)tipShow
{
    tipLabel.hidden = NO;
    tipImageView.hidden = NO;
}

- (void)tipHidden
{
    tipImageView.hidden = YES;
    tipLabel.hidden = YES;
}

- (void)closeAction
{
    NSLog(@"%s",__func__);
    
    [self dismiss];
    
}

- (void)submitAction
{
    NSLog(@"%s",__func__);
    if (self.type == PassViewTypeSubmit) {
        //支付
        if(self.delegate && [self.delegate respondsToSelector:@selector(payWithAlert:)]){
            [self.delegate payWithAlert:self];
        }
        
    } else if (self.type == PassViewTypeSubmitTip) {
        //充值
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(RechargeWithAlert:)]) {
            [self.delegate RechargeWithAlert:self];
        }
        [self dismiss];
    }
}

- (void)bottonAction
{
    NSLog(@"%s",__func__);
    
    if (self.type == PassViewTypeSubmitTip) {
        // 取消
    } else
    {
        //忘记密码
        [self forgetPassword];
    }
    [self dismiss];
    
    
}

- (void)forgetPassword
{
    if ([self.delegate respondsToSelector:@selector(forgetPasswordActionWith:)]) {
        [self.delegate forgetPasswordActionWith:self];
    }
}

- (void)showKeyBoard{
    [tf becomeFirstResponder];
}

- (void)cleanPsdView{
    for (UIImageView *iv in enterPsdViews) {
        iv.highlighted = NO;
    }
    selectedIvTag = IVTag;
}


- (void)changeInputState
{
    for (UIImageView *iv in enterPsdViews) {
        iv.highlighted = NO;
    }
    [psdArray removeAllObjects];
    self.canInputPassword = YES;
    
}


- (void)startSureBtnAction{
    self.canInputPassword = NO;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf sureBtnAction];
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
    
//    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
//    if(person){
//        NSString *input = [enterPassword stringByAppendingString:person.payPsdSalt];
//        self.verPayPsdManager.password = [input getSha1String];
//        [self.verPayPsdManager loadData];
//    }
}


#pragma mark - APIManagerCallBackDelegate

//- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
//    
//    NSLog(@"验证成功");
//    //本地验证次数归零
//    [WJGlobalVariable payPasswordVerifySuccess];
//    
//    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
//    if (person) {
//        NSString *text = [[enterPassword stringByAppendingString:person.payPsdSalt] getSha1String];
//        if (![person.payPassword isEqualToString:text]) {
//            person.payPassword = text;
//            [[WJDBPersonManager new] updatePerson:person];
//        }
//    }
//    
//    
//    [self dismiss];
//    
//    if(self.delegate && [self.delegate respondsToSelector:@selector(successWithVerifyPsdAlert:)]){
//        
//        [self.delegate successWithVerifyPsdAlert:self];
//    }
//}
//
//
//- (void)managerCallAPIDidFailed:(APIBaseManager *)manager{
//    
//    NSLog(@"验证失败");
//    [psdArray removeAllObjects];
//    [tf resignFirstResponder];
//    
//    //验证失败
//    if (manager.errorCode == 50008052 || manager.errorCode == 50008053) {
//        
//        NSDictionary *dic = [manager fetchDataWithReformer:nil];
//        [self recordErrorNumber];
//        
//        NSString *errMsg = manager.errorMessage;
//        if (errMsg) {
//            if (errMsg.length > 0) {
//                
//                if (self.delegate && [self.delegate respondsToSelector:@selector(failedWithVerifyPsdAlert:errerMessage:isLocked:)]) {
//                    [self.delegate failedWithVerifyPsdAlert:self errerMessage:manager.errorMessage isLocked:[dic[@"lockedStatus"] boolValue] ?YES:NO];
//                }
//            }
//        }else{
//            //text变可编辑
//            self.canInputPassword = YES;
//            [self showKeyBoard];
//        }
//        
//    }else{
//        
//        if (manager.errorMessage) {
//            if ([manager.errorMessage length] > 0) {
//                [[TKAlertCenter defaultCenter] postAlertWithMessage:manager.errorMessage];
//            }
//        }
//        //text变可编辑
//        self.canInputPassword = YES;
//        [self showKeyBoard];
//    }
//}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.canInputPassword) {
        if (string.length == 0) {
            if (selectedIvTag > IVTag) {
                selectedIvTag -= 1;
                UIImageView *iv = (UIImageView *)[self viewWithTag:selectedIvTag];
                iv.highlighted = NO;
                [psdArray removeLastObject];
            }
        }else{
            if (selectedIvTag < 206) {
                UIImageView *iv = (UIImageView *)[self viewWithTag:selectedIvTag];
                iv.highlighted = YES;
                selectedIvTag += 1;
                [psdArray addObject:string];
                
                if (selectedIvTag == 206) {
                    [self performSelector:@selector(startSureBtnAction) withObject:nil afterDelay:0.3];
                }
            }
        }
    }
    
    return self.canInputPassword;
}


#pragma mark - 存储路径和时间比较方法

- (NSInteger)distanceTimeWithBeforeTime:(NSInteger)beTime
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSInteger distance = now - beTime;
    return distance;
}

- (void)recordErrorNumber
{
    NSInteger faileNumber = [[dataDic objectForKey:@"errorCount"] intValue];
    if (faileNumber < 5) {
        
        [dataDic setObject:[NSString stringWithFormat:@"%@",@(++faileNumber)] forKey:@"errorCount"];
        NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        [dataDic setObject:nowTime forKey:@"time"];
        
        //记录第一次错误的时间
        if(faileNumber == 1){
            [dataDic setObject:nowTime forKey:@"limiteTime"];
        }
        
        [dataDic writeToFile:[WJGlobalVariable payPasswordVerifyFailedErrorFilePatch] atomically:YES];
    }
}

#pragma mark - 属性访问方法
- (void)setAlertTag:(NSInteger)alertTag
{
    if (_alertTag != alertTag) {
        _alertTag = alertTag;
        self.tag = alertTag;
    }
}

//- (APIVerifyPayPwdManager *)verPayPsdManager
//{
//    if (nil == _verPayPsdManager) {
//        _verPayPsdManager = [[APIVerifyPayPwdManager alloc] init];
//        _verPayPsdManager.delegate = self;
//    }
//    
//    return _verPayPsdManager;
//}



@end
