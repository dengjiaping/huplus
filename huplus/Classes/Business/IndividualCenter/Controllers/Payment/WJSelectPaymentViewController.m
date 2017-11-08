//
//  WJSelectPaymentViewController.m
//  HuPlus
//
//  Created by reborn on 17/1/11.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJSelectPaymentViewController.h"
#import "WJPassView.h"
#import "WJSystemAlertView.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WJPayResultViewController.h"
#import "APIPayMentManager.h"
#import "WeixinPayManager.h"
#import "AlipayManager.h"

@interface WJSelectPaymentViewController ()<UITableViewDelegate,UITableViewDataSource,WJPassViewDelegate,WJSystemAlertViewDelegate>
{
    UIButton *payRightNowButton;
}
@property(nonatomic,strong)UITableView              * tableView;
@property(nonatomic,strong)NSMutableArray           * payArray;
@property(nonatomic,assign)NSInteger                  selectPayAwayIndex;
@property(nonatomic,strong)APIPayMentManager        * payMentManager;

@end

@implementation WJSelectPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择支付方式";
    self.isHiddenTabBar = YES;
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    
    
    NSArray *paymentArray = [self.paymentModel.payMentType componentsSeparatedByString:@","];
    
    for (id object in paymentArray) {
        
        NSInteger payIndex = (NSInteger)[object integerValue];
        
        if (payIndex == 1) {
            
            [_payArray addObject:@{@"image":@"pay_alipay",@"text":@"支付宝支付",@"away":@"alipay"}];
            
        } else if (payIndex == 2) {
            
            [_payArray addObject:@{@"image":@"pay_weixin",@"text":@"微信支付",@"away":@"weixin"}];

            
        } else if (payIndex == 3) {
            
            [_payArray addObject:@{@"image":@"pay_vipCard",@"text":@"贵宾卡支付",@"away":@"vipCard"}];

        }
    }
    
    [self UISetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)UISetup
{
    payRightNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payRightNowButton.frame = CGRectMake(ALD(20), self.tableView.height - ALD(80), kScreenWidth - ALD(40), ALD(40));
    [payRightNowButton setTitle:@"立即支付" forState:UIControlStateNormal];
    payRightNowButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [payRightNowButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    payRightNowButton.backgroundColor = WJColorMainRed;
    payRightNowButton.layer.cornerRadius = 4;
    payRightNowButton.layer.masksToBounds = YES;
    payRightNowButton.titleLabel.font = WJFont14;
    
    [payRightNowButton addTarget:self action:@selector(payRightNowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView addSubview:payRightNowButton];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIPayMentManager class]]) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if ([self.payMentManager.payType isEqualToString:@"1"]) {
            [AlipayManager alipayManager].selectPaymentVC = self;
            [AlipayManager alipayManager].totleCash = dic[@"order_total"];
            [[AlipayManager alipayManager]callAlipayWithOrderString:dic[@"prepayid"]];
        }else if ([self.payMentManager.payType isEqualToString:@"2"]){
            [WeixinPayManager WXPayManager].selectPaymentVC = self;
            [WeixinPayManager WXPayManager].totleCash = dic[@"order_total"];
            [[WeixinPayManager WXPayManager]callWexinPayWithPrePayid:dic[@"prepayid"]];
        }
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    } else {
        return self.payArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(44);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return ALD(10);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectPaymentIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectPaymentIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorWhite;
    }
    
    switch (indexPath.section) {
        case 0:
        {
            UILabel *orderAmountL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), 0, ALD(60), ALD(44))];
            orderAmountL.text = @"订单金额";
            orderAmountL.font = WJFont14;
            orderAmountL.textColor = WJColorNavigationBar;
            [cell.contentView addSubview:orderAmountL];
            
            UILabel *amountL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(100), 0, ALD(100), ALD(44))];
            amountL.text = [NSString stringWithFormat:@"¥%@",self.paymentModel.orderTotal];
            amountL.font = WJFont14;
            amountL.textColor = WJColorMainRed;
            amountL.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:amountL];

        }
            break;
            
        case 1:
        {
            UIImageView *logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), ALD(11), ALD(22), ALD(22))];
            logoIV.tag = 10000 + indexPath.row;
            
            UILabel  *nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoIV.frame) + ALD(11), ALD(11), ALD(11), ALD(22))];
            nameL.textColor = WJColorNavigationBar;
            nameL.font = WJFont14;
            nameL.tag = 11000 + indexPath.row;
            
            UIImageView *selectIV = [[UIImageView alloc] init];
            [selectIV setFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(7), ALD(15), ALD(13), ALD(13))];
            selectIV.tag = 13000 + indexPath.row;
            
            UILabel *balanceDesL = [[UILabel alloc] initWithFrame:CGRectMake(nameL.right + ALD(5), 0, ALD(100), ALD(44))];
            balanceDesL.hidden = YES;
            balanceDesL.textColor = WJColorLightGray;
            balanceDesL.text = [NSString stringWithFormat:@"(余额：¥%@)",self.paymentModel.orderTotal];
            balanceDesL.font = WJFont12;
            balanceDesL.tag = 14000 + indexPath.row;
            
            
            [cell.contentView addSubview:logoIV];
            [cell.contentView addSubview:nameL];
            [cell.contentView addSubview:selectIV];
            [cell.contentView addSubview:balanceDesL];
        }
            
        default:
            break;
    }
    
    if (indexPath.section == 1) {
        
        UIImageView *logoIV = (UIImageView *)[cell.contentView viewWithTag:10000 + indexPath.row];
        UILabel     *nameL = (UILabel  *)[cell.contentView viewWithTag:11000 + indexPath.row];
        UIImageView *selectIV = (UIImageView *)[cell.contentView viewWithTag:13000 + indexPath.row];
        UILabel     *balanceDesL = (UILabel *)[cell.contentView viewWithTag:14000 + indexPath.row];
        
        logoIV.image = [UIImage imageNamed:[[self.payArray objectAtIndex:indexPath.row] objectForKey:@"image"]];
        nameL.text = [[self.payArray objectAtIndex:indexPath.row] objectForKey:@"text"];
        [nameL sizeToFit];
        [nameL setFrame:CGRectMake(nameL.x, nameL.y, nameL.width, ALD(22))];
        
        if (self.selectPayAwayIndex == indexPath.row) {
            selectIV.image = [UIImage imageNamed:@"toggle_button_selected"];
        } else {
            selectIV.image = [UIImage imageNamed:@"toggle_button_nor"];
        }
        
        if (indexPath.row == 2) {
            balanceDesL.hidden = NO;
            balanceDesL.frame = CGRectMake(nameL.right + ALD(5), 0, ALD(100), ALD(44));
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectPayAwayIndex = indexPath.row;
    [self.tableView reloadData];
    
}

#pragma mark - Action
-(void)payRightNowButtonAction
{
    [MobClick event:@"zhifu"];
    
    //调支付宝、微信、贵宾卡支付
    switch (self.selectPayAwayIndex) {
        case 0:
        {
            //支付宝
            self.payMentManager.payType = @"1";
        }
            break;
            
        case 1:
        {
            //微信
            self.payMentManager.payType = @"2";
        }
            break;
            
//        case 2:
//        {
//            //贵宾卡
//            self.payManager.payType = @"3";
//
//        }
//            break;
            
            
        default:
            break;
    }
    
    [self.payMentManager loadData];
    
    //贵宾卡支付
    
//    NSInteger totalAmount = 2;
//    NSInteger balanceAmount = 0;
    
//    if (totalAmount >= balanceAmount) {
//        
//        //判断是否设置了指纹验证
//        NSString *fingerIdenty = KFingerIdentySwitch;
//        BOOL isBool = NO;
//        if (fingerIdenty) {
//            isBool = [[NSUserDefaults standardUserDefaults] boolForKey:fingerIdenty];
//        }
//        
//        if (isBool) {
//            
//            WJPassView *passView = [[WJPassView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - ALD(50)) title:@"请输入支付密码" productName:@"杰克琼斯2016新款男士外套" amountNeedNum:@"30" balanceHasNum:@"6374" passViewType:PassViewTypeSubmit];
//            
//            passView.delegate = self;
//            [passView showIn];
//            
//        } else {
//            
//            WJPassView *passView = [[WJPassView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - ALD(50)) title:@"请输入支付密码" productName:@"杰克琼斯2016新款男士外套" amountNeedNum:@"30" balanceHasNum:@"6374" passViewType:PassViewTypeInputPassword];
//            
//            passView.delegate = self;
//            [passView showIn];
//            
//        }
//    } else {
//        
//        WJPassView *passView = [[WJPassView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - ALD(50)) title:@"请输入支付密码" productName:@"杰克琼斯2016新款男士外套" amountNeedNum:@"30" balanceHasNum:@"6374" passViewType:PassViewTypeSubmitTip];
//        
//        passView.delegate = self;
//        [passView showIn];
//    }
    

//    WJPassView *passView = [[WJPassView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - ALD(50)) title:@"请输入支付密码" productName:@"杰克琼斯2016新款男士外套" amountNeedNum:@"30" balanceHasNum:@"6374" passViewType:PassViewTypeInputPassword];
//    
//    passView.delegate = self;
//    [passView showIn];
    
}


#pragma mark - WJPassViewDelegate
//- (void)successWithVerifyPsdAlert:(WJPassView *)alertView
//{
//    self.buyECardManager.orderNo = orderNumber;
//    [self.buyECardManager loadData];
//    
//    //支付失败 弹错误提示
//    WJSystemAlertView *sysAlert = [[WJSystemAlertView alloc] initWithTitle:@"支付失败" message:@"支付遇到问题，您可以到我的订单页面查看订单详情" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
//    [sysAlert showIn];
//    
//}


//- (void)failedWithVerifyPsdAlert:(WJPassView *)alertView errerMessage:(NSString * )errerMessage isLocked:(BOOL)isLocked
//{
//    [alertView dismiss];
//    
//    //失败重新弹出输入弹窗
//    [self showAlertWithMessage:errerMessage isLocked:isLocked];
//}


//- (void)forgetPasswordActionWith:(WJPassView *)alertView
//{
//    [alertView dismiss];
//    [self findPassword];
//}

//确认支付（已开启指纹）
//- (void)payWithAlert:(WJPassView *)alertView
//{
//    [alertView dismiss];
//    [self checkFingerWithIdenty];
//    
//}

//立即充值
//- (void)RechargeWithAlert:(WJPassView *)alertView
//{
//}

#pragma mark - 指纹校验
//- (void)checkFingerWithIdenty
//{
//    if(IOS8_LATER){
//        
//        //进行指纹识别，获取指纹验证结果
//        LAContext *context = [[LAContext alloc] init];
//        context.localizedFallbackTitle = @"输入支付密码";
//        
//        __weak typeof(self) weakSelf = self;
//        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"通过Home键验证已有手机指纹",nil) reply:^(BOOL success, NSError * _Nullable error) {
//            
//            __strong typeof(self) strongSelf = weakSelf;
//            
//            if (success) {
//                //验证成功，主线程处理UI
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    
////                    strongSelf.buyECardManager.orderNo = orderNumber;
////                    [strongSelf.buyECardManager loadData];
//                    
//                }];
//                
//            }else{
//                
//                NSLog(@"%@",error.localizedDescription);
//            }
//        }];
//    }
//}

//#pragma mark - 找回密码逻辑
//- (void)showAlertWithMessage:(NSString *)msg isLocked:(BOOL)isLocked
//{
//    NSString *title = nil;
//    NSString *otherBtnTitle = nil;
//    if (isLocked) {
//        title = @"账号已被锁定";
//        otherBtnTitle = @"找回支付密码";
//    }else{
//        title = @"验证失败";
//        otherBtnTitle = @"再试一次";
//    }
//    
//    WJSystemAlertView *sysAlert = [[WJSystemAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:otherBtnTitle textAlignment:NSTextAlignmentCenter];
//    
//    [sysAlert showIn];
//}
//
//- (void)findPassword
//{
//    
//}
//
//#pragma mark - WJSystemAlertViewDelegate
//- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    //取消
//    if (buttonIndex == 0) {
//        [alertView dismiss];
//    }else{
//        
//        if ([alertView.title isEqualToString:@"验证失败"]) {
//            //再试一次
//            WJPassView *passView = [[WJPassView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - ALD(50)) title:@"请输入支付密码" productName:@"杰克琼斯2016新款男士外套" amountNeedNum:@"30" balanceHasNum:@"6374" passViewType:PassViewTypeInputPassword];
//            
//            passView.delegate = self;
//            [passView showIn];
//            
//            
//        }else if ([alertView.title isEqualToString:@"账号已被锁定"]) {
//            
//            [alertView dismiss];
//            [self findPassword];
//        }
//    }
//}

#pragma mark - 属性方法
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorColor = WJColorSeparatorLine;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)payArray
{
    if (!_payArray) {
        _payArray = [NSMutableArray array];
    }
    
    return _payArray;
}

- (APIPayMentManager *)payMentManager
{
    if (_payMentManager == nil) {
        _payMentManager = [[APIPayMentManager alloc]init];
        _payMentManager.delegate = self;
    }
    _payMentManager.userId = USER_ID;
    _payMentManager.orderId = self.paymentModel.orderId;
    return _payMentManager;
}

@end
