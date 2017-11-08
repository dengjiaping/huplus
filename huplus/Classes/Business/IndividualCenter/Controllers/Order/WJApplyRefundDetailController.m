//
//  WJApplyRefundDetailController.m
//  HuPlus
//
//  Created by reborn on 17/4/20.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJApplyRefundDetailController.h"
#import "WJApplyRefundListCell.h"
#import "WJServiceTypeView.h"
#import "WJAfterSalesResultController.h"
#import <AFNetworking/AFNetworking.h>
#import "SecurityService.h"
#import "APIOrderDetailRefundManager.h"
#import "WJExpressView.h"
#import "WJRefundPickerView.h"
#import "WJLogisticsCompanyModel.h"
#import "APIOnlyRefundManager.h"

#define kApplyRefundListCellIdentifier      @"kApplyRefundListCellIdentifier"

@interface WJApplyRefundDetailController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,APIManagerCallBackDelegate,WJExpressViewDelegate,WJRefundPickerViewDelegate>
@property(nonatomic,strong)APIOnlyRefundManager         *onlyRefundManager;
@property(nonatomic,strong)UITableView                  *tableView;
@property(nonatomic,strong)WJExpressView                *refundExpressView;
@property(nonatomic,strong)WJExpressView                *amountExpressView;
@property(nonatomic,strong)WJRefundPickerView           *refundPickerView;
@property(nonatomic,strong)UIView                       *maskView;
@end

@implementation WJApplyRefundDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请退款";
    self.isHiddenTabBar = YES;
    
    [self.view addSubview:self.tableView];
    [self initBottomView];
}

-(void)initBottomView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(65))];
    footerView.backgroundColor = WJColorViewBg;
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(ALD(20), ALD(10), kScreenWidth - ALD(40), ALD(40));
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    submitButton.backgroundColor = WJColorMainRed;
    submitButton.layer.cornerRadius = 4;
    submitButton.layer.borderColor = WJColorMainRed.CGColor;
    submitButton.layer.borderWidth = 0.5;
    submitButton.titleLabel.font = WJFont14;
    [submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitButton];
    
    self.tableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIOnlyRefundManager class]]) {
        
        WJAfterSalesResultController *afterSalesResultVC = [[WJAfterSalesResultController alloc] init];
        afterSalesResultVC.serviceType = 0;
        [self.navigationController pushViewController:afterSalesResultVC animated:YES whetherJump:YES];
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section>0?ALD(15):0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        return ALD(150);
    } else if (section == 1) {
        return ALD(80);
    } else if (section == 2) {
        return ALD(80);
    } else {
        return ALD(80);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        
        WJApplyRefundListCell *applyRefundListCell = [[WJApplyRefundListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kApplyRefundListCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell  = applyRefundListCell;
        [applyRefundListCell configDataWithModel:self.productModel isDetail:YES];
        
        
    } else if (section == 1) {
        
        WJServiceTypeView *serviceTypeView = [[WJServiceTypeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(90))];
        serviceTypeView.serviceType = 0;
        [cell.contentView addSubview:serviceTypeView];
        
        
    } else if (section == 2) {
        
        _refundExpressView = [[WJExpressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(80))];
        _refundExpressView.delegate = self;
        [_refundExpressView configDataWithTitle:@"退款原因" placeholder:@"请选择退款原因" isShowArrowIV:YES];
        [cell.contentView addSubview:_refundExpressView];
        
        
    } else if (section == 3) {
        
        _amountExpressView = [[WJExpressView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, ALD(80))];
        _amountExpressView.delegate = self;
        [_amountExpressView configDataWithTitle:@"退款金额" placeholder:nil isShowArrowIV:NO];
        
        NSString *amount = [NSString stringWithFormat:@"%.2f",[self.productModel.refundPrice floatValue]];
        NSString *logisticsAmount = [NSString stringWithFormat:@"%.2f",[self.productModel.logisticsCost floatValue]];
        NSString *refundAmountStr =  [NSString stringWithFormat:@"¥%@(最多可退¥%@，含发货邮费¥%@)",amount,amount,logisticsAmount];
        
        _amountExpressView.expressTF.attributedText = [self attributedText:refundAmountStr firstLength:amount.length + 1];
        _amountExpressView.expressTF.enabled = NO;
        [cell.contentView addSubview:_amountExpressView];
        
    }
    return cell;
}

- (NSAttributedString *)attributedText:(NSString *)text firstLength:(NSInteger)len{
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
                                         initWithString:text];
    NSDictionary *attributesForFirstWord = @{
                                             NSFontAttributeName : WJFont12,
                                             NSForegroundColorAttributeName : WJColorMainRed,
                                             };
    
    NSDictionary *attributesForSecondWord = @{
                                              NSFontAttributeName : WJFont12,
                                              NSForegroundColorAttributeName : WJColorDardGray9,
                                              };
    [result setAttributes:attributesForFirstWord
                    range:NSMakeRange(0, len)];
    [result setAttributes:attributesForSecondWord
                    range:NSMakeRange(len, text.length - len)];
    
    
    return [[NSAttributedString alloc] initWithAttributedString:result];
}

#pragma mark - WJRefundPickerView
-(void)refundPickerView:(WJRefundPickerView *)refundPickerView clickCancelButton:(UIButton *)cancelButton
{
    [_maskView removeFromSuperview];
    
}

-(void)refundPickerView:(WJRefundPickerView *)refundPickerView clickConfirmButtonWithLogisticsCompanyModel:(WJLogisticsCompanyModel *)logisticsCompanyModel
{
    [_maskView removeFromSuperview];
    self.refundExpressView.expressTF.text = logisticsCompanyModel.logisticsCompanyName;
}

#pragma mark - WJExpressViewDelegate
-(void)startEditExpressView:(UITextField *)textField
{
    if (textField == _refundExpressView.expressTF) {
        
        [_refundExpressView.expressTF resignFirstResponder];
        [self.view addSubview:self.maskView];
        [self.maskView addSubview:self.refundPickerView];
    }
}

-(void)endEditExpressView:(UITextField *)textField
{
    
}


#pragma mark - Action

-(void)submitButtonAction
{
    if (self.refundExpressView.expressTF.text.length > 0) {
        
        [self showLoadingView];
        [self.onlyRefundManager loadData];
    }
}

#pragma mark- Event Response
-(void)tapMaskViewgesture:(UITapGestureRecognizer*)tap
{
    [tap.view removeFromSuperview];
}


#pragma mark - setter& getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorInset = UIEdgeInsetsZero;
        
    }
    return _tableView;
}


-(WJRefundPickerView *)refundPickerView
{
    if (nil == _refundPickerView) {
        _refundPickerView = [[WJRefundPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - ALD(300), kScreenWidth, ALD(300))];
        _refundPickerView.delegate = self;
        
        WJLogisticsCompanyModel *model1 = [[WJLogisticsCompanyModel alloc] init];
        model1.logisticsCompanyName = @"我不想买了";
        
        WJLogisticsCompanyModel *model2 = [[WJLogisticsCompanyModel alloc] init];
        model2.logisticsCompanyName = @"信息填写错误，重新拍";
        
        WJLogisticsCompanyModel *model3 = [[WJLogisticsCompanyModel alloc] init];
        model3.logisticsCompanyName = @"卖家缺货";
        
        WJLogisticsCompanyModel *model4 = [[WJLogisticsCompanyModel alloc] init];
        model4.logisticsCompanyName = @"其他原因";
        
        _refundPickerView.expressListArray = [NSMutableArray arrayWithObjects:model1,model2,model3,model4,nil];
    }
    return _refundPickerView;
}

-(UIView *)maskView
{
    if (nil == _maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = WJColorBlack;
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        UITapGestureRecognizer *tapGestureAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskViewgesture:)];
        [_maskView addGestureRecognizer:tapGestureAddress];
        
    }
    return _maskView;
}

-(APIOnlyRefundManager *)onlyRefundManager
{
    if (_onlyRefundManager == nil) {
        _onlyRefundManager = [[APIOnlyRefundManager alloc] init];
        _onlyRefundManager.delegate = self;
    }
    _onlyRefundManager.userId = USER_ID;
    _onlyRefundManager.orderId = self.orderId;
    _onlyRefundManager.skuId = self.productModel.skuId;
    _onlyRefundManager.refundReason = self.refundExpressView.expressTF.text;
    _onlyRefundManager.refundTotalMoney = [NSString stringWithFormat:@"%.2f",[self.productModel.refundPrice floatValue]];
    return _onlyRefundManager;
}

@end
