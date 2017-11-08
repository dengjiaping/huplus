//
//  WJMailMessageViewController.m
//  HuPlus
//
//  Created by reborn on 17/3/24.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJMailMessageViewController.h"
#import "WJExpressView.h"
#import "WJRefundPickerView.h"
#import "APIQueryLogisticsListManager.h"
#import "WJLogisticsListReformer.h"
#import "APIAddInvoiceManager.h"
@interface WJMailMessageViewController ()<WJExpressViewDelegate,WJRefundPickerViewDelegate,APIManagerCallBackDelegate>
@property(nonatomic,strong)APIQueryLogisticsListManager *queryLogisticsListManager;
@property(nonatomic,strong)APIAddInvoiceManager         *addInvoiceManager;
@property(nonatomic,strong)WJExpressView                *expressView;
@property(nonatomic,strong)WJExpressView                *expressNumberView;
@property(nonatomic,strong)WJRefundPickerView           *refundPickerView;
@property(nonatomic,strong)UIView                       *maskView;
@property(nonatomic,strong)NSMutableArray               *listArray;
@property(nonatomic,strong)WJLogisticsCompanyModel      *selectLogisticsCompanyModel;


@end

@implementation WJMailMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenTabBar = YES;
    self.title = @"邮寄信息";
    
    [self setUpView];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:tapGesture];

    // Do any additional setup after loading the view.
    [self.queryLogisticsListManager loadData];
}

-(void)setUpView
{
    [self.view addSubview:self.expressView];
    [self.view addSubview:self.expressNumberView];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(ALD(12), self.expressNumberView.bottom + ALD(40), kScreenWidth - ALD(24), ALD(40));
    [submitButton setTitle:@"保存并提交"
                         forState:UIControlStateNormal];
    [submitButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    submitButton.backgroundColor = WJColorMainRed;
    submitButton.titleLabel.font = WJFont15;
    submitButton.layer.cornerRadius = 4;
    submitButton.layer.masksToBounds = YES;
    [submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

-(void)submitButtonAction
{
    if (_expressView.expressTF.text.length > 0 && _expressNumberView.expressTF.text.length > 0) {
        
        [self showLoadingView];
        [self.addInvoiceManager loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIQueryLogisticsListManager class]]) {
        
        NSMutableDictionary *dic = [manager fetchDataWithReformer:[[WJLogisticsListReformer alloc] init]];
        self.listArray = dic[@"logistics_list"];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIAddInvoiceManager class]]) {
        
        [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
    }
}

#pragma mark- Event Response
-(void)tapMaskViewgesture:(UITapGestureRecognizer*)tap
{
    [tap.view removeFromSuperview];
}

-(void)tapGesture
{
    [_expressNumberView.expressTF resignFirstResponder];
}

#pragma mark - WJExpressViewDelegate
-(void)startEditExpressView:(UITextField *)textField
{
    if (textField == _expressView.expressTF) {
        
        [_expressView.expressTF resignFirstResponder];
        
        self.refundPickerView.expressListArray = self.listArray;
        [self.view addSubview:self.maskView];
        [self.maskView addSubview:self.refundPickerView];
    }
}


-(void)endEditExpressView:(UITextField *)textField
{

}

#pragma mark - WJRefundPickerView
-(void)refundPickerView:(WJRefundPickerView *)refundPickerView clickCancelButton:(UIButton *)cancelButton
{
    [_maskView removeFromSuperview];
}

-(void)refundPickerView:(WJRefundPickerView *)refundPickerView clickConfirmButtonWithLogisticsCompanyModel:(WJLogisticsCompanyModel *)logisticsCompanyModel
{
    [_maskView removeFromSuperview];
    self.expressView.expressTF.text = logisticsCompanyModel.logisticsCompanyName;
    self.selectLogisticsCompanyModel = logisticsCompanyModel;
}

-(WJExpressView *)expressView
{
    if (_expressView == nil) {
        _expressView = [[WJExpressView alloc] initWithFrame:CGRectMake(0, ALD(10), kScreenWidth, ALD(80))];
        _expressView.delegate = self;
        [_expressView configDataWithTitle:@"快递单位" placeholder:@"请选择快递单位" isShowArrowIV:YES];
        
    }
    return _expressView;
}

-(WJExpressView *)expressNumberView
{
    if (_expressNumberView == nil) {
        _expressNumberView = [[WJExpressView alloc] initWithFrame:CGRectMake(0, ALD(100), kScreenWidth, ALD(80))];
        _expressNumberView.delegate = self;
        [_expressNumberView configDataWithTitle:@"快递编号" placeholder:@"请输入正确的快递编号" isShowArrowIV:NO];

    }
    return _expressNumberView;
}

-(WJRefundPickerView *)refundPickerView
{
    if (nil == _refundPickerView) {
        _refundPickerView = [[WJRefundPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - ALD(300), kScreenWidth, ALD(300))];
        _refundPickerView.delegate = self;
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

-(APIQueryLogisticsListManager *)queryLogisticsListManager
{
    if (_queryLogisticsListManager == nil) {
        _queryLogisticsListManager = [[APIQueryLogisticsListManager alloc] init];
        _queryLogisticsListManager.delegate = self;
    }
    return _queryLogisticsListManager;
}

-(APIAddInvoiceManager *)addInvoiceManager
{
    if (_addInvoiceManager == nil) {
        _addInvoiceManager = [[APIAddInvoiceManager alloc] init];
        _addInvoiceManager.delegate = self;
    }
    _addInvoiceManager.userId = USER_ID;
    _addInvoiceManager.refundId = self.orderModel.refundId;
    _addInvoiceManager.logisticsId = self.selectLogisticsCompanyModel.logisticsCompanyId;
    _addInvoiceManager.logisticsNo = _expressNumberView.expressTF.text;
    _addInvoiceManager.logisticsName = self.selectLogisticsCompanyModel.logisticsCompanyName;
    return _addInvoiceManager;
}

-(NSMutableArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

@end
