//
//  WJMyOrderController.m
//  HuPlus
//
//  Created by reborn on 16/12/21.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJMyOrderController.h"
#import "WJSegmentedView.h"
#import "WJMyAllOrderController.h"
#import "WJWaitingOrderController.h"
#import "WJWaitingReceivingController.h"
#import "WJFinishOrderController.h"
#import "WJMyOrderControllerDelegate.h"
#import "WJLogisticsDetailViewController.h"
#import "WJOrderDetailController.h"
#import "WJWaitingDeliverController.h"
#import "APICancelOrderManager.h"
#import "APIConfirmReceiveManager.h"
#import "WJSystemAlertView.h"
#import "APIConfirmReceiveManager.h"
#import "APIPayManager.h"
#import "WJSelectPaymentViewController.h"
#import "WJRefundPickerView.h"
#define kOrderTabSegmentHeight      ALD(50)

@interface WJMyOrderController ()<WJSegmentedViewDelegate,UIScrollViewDelegate,WJMyOrderControllerDelegate,WJSystemAlertViewDelegate,WJRefundPickerViewDelegate>
{
    WJSegmentedView              *segmentedView;
    UIScrollView                 *baseScrollView;
    WJMyAllOrderController       *allOrderVC;
    WJWaitingOrderController     *waitingOrderVC;
    WJWaitingDeliverController   *waitDeliverVC;
    WJWaitingReceivingController *waitingReceivingOrderVC;
//    WJFinishOrderController      *finishOrderVC;
}
@property(nonatomic,strong)APICancelOrderManager    *cancelOrderManager;
@property(nonatomic,strong)APIConfirmReceiveManager *confirmReceiveManager;
@property(nonatomic,strong)APIPayManager            *payRightManager;     //立即付款
@property(nonatomic,strong)WJOrderModel             *orderModel;

@property(nonatomic,strong)WJRefundPickerView       *refundPickerView;
@property(nonatomic,strong)UIView                   *maskView;

@end

@implementation WJMyOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的订单";
    self.isHiddenTabBar = YES;

    segmentedView  = [[WJSegmentedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kOrderTabSegmentHeight) items:@[@"全部",@"待付款",@"待发货",@"待收货"]];
    [segmentedView setBottomLineView:YES];

    segmentedView.delegate = self;
    [self.view addSubview:segmentedView];
    
    baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentedView.bottom, kScreenWidth, (kScreenHeight- kNavigationBarHeight - kOrderTabSegmentHeight))];
    baseScrollView.pagingEnabled = YES;
    baseScrollView.bounces = NO;
    baseScrollView.scrollsToTop = NO;
    baseScrollView.delegate = self;
    baseScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:baseScrollView];
    
    allOrderVC = [[WJMyAllOrderController alloc] init];
    allOrderVC.view.frame = CGRectMake(0, 0, kScreenWidth, baseScrollView.height);
    allOrderVC.delegate = self;
    [self addChildViewController:allOrderVC];
    [allOrderVC didMoveToParentViewController:self];
    [baseScrollView addSubview:allOrderVC.view];
    
    waitingOrderVC = [[WJWaitingOrderController alloc] init];
    waitingOrderVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, baseScrollView.height);
    waitingOrderVC.delegate = self;
    [self addChildViewController:waitingOrderVC];
    [waitingOrderVC didMoveToParentViewController:self];
    [baseScrollView addSubview:waitingOrderVC.view];
    
    waitDeliverVC = [[WJWaitingDeliverController alloc] init];
    waitDeliverVC.view.frame = CGRectMake(2*kScreenWidth, 0, kScreenWidth, baseScrollView.height);
    waitDeliverVC.delegate = self;
    [self addChildViewController:waitDeliverVC];
    [waitDeliverVC didMoveToParentViewController:self];
    [baseScrollView addSubview:waitDeliverVC.view];
    
    waitingReceivingOrderVC = [[WJWaitingReceivingController alloc] init];
    waitingReceivingOrderVC.view.frame = CGRectMake(3*kScreenWidth, 0, kScreenWidth, baseScrollView.height);
    waitingReceivingOrderVC.delegate = self;
    [self addChildViewController:waitingReceivingOrderVC];
    [waitingReceivingOrderVC didMoveToParentViewController:self];
    [baseScrollView addSubview:waitingReceivingOrderVC.view];
    
//    finishOrderVC = [[WJFinishOrderController alloc] init];
//    finishOrderVC.view.frame = CGRectMake(4*kScreenWidth, 0, kScreenWidth, baseScrollView.height);
//    finishOrderVC.delegate = self;
//    [self addChildViewController:finishOrderVC];
//    [finishOrderVC didMoveToParentViewController:self];
//    [baseScrollView addSubview:finishOrderVC.view];
    
    baseScrollView.contentSize = CGSizeMake(4*kScreenWidth, baseScrollView.height);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.scrollIndex) {
        
        self.scrollIndex = 0;
    }
    
    if (self.scrollIndex == 0) {
        
        segmentedView.selectedSegmentIndex = 0;
        [self segmentedView:segmentedView buttonClick:0];
        
    } else if (self.scrollIndex == 1) {
        
        segmentedView.selectedSegmentIndex = 1;
        [self segmentedView:segmentedView buttonClick:1];

    } else if (self.scrollIndex == 2) {
        
        segmentedView.selectedSegmentIndex = 2;
        [self segmentedView:segmentedView buttonClick:2];
        
    } else {
        segmentedView.selectedSegmentIndex = 3;
        [self segmentedView:segmentedView buttonClick:3];
    }

}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APICancelOrderManager class]]) {
        
        [waitDeliverVC.tableView startHeadRefresh];
        
    } else if ([manager isKindOfClass:[APIConfirmReceiveManager class]]) {

        [waitingReceivingOrderVC.tableView startHeadRefresh];
        
    } else {
        
        [self hiddenLoadingView];
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        WJPaymentModel *paymentModel = [[WJPaymentModel alloc] initWithDic:dic];
        
        [WJGlobalVariable sharedInstance].payfromController = self;
        
        WJSelectPaymentViewController *selectPaymentVC = [[WJSelectPaymentViewController alloc] init];
        selectPaymentVC.paymentModel = paymentModel;
        [self.navigationController pushViewController:selectPaymentVC animated:YES whetherJump:YES];
    }
    
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
}


#pragma mark - WJSegmentedViewDelegate
-(void)segmentedView:(WJSegmentedView *)segmentedView buttonClick:(NSInteger)index
{
    [UIView animateWithDuration:0.3 animations:^{
        baseScrollView.contentOffset = CGPointMake(kScreenWidth*index, 0);
    }];
    
    switch (index) {
        case 0:
            [allOrderVC.tableView startHeadRefresh];

            break;
        case 1:
            [waitingOrderVC.tableView startHeadRefresh];

            break;
            
        case 2:
            [waitDeliverVC.tableView startHeadRefresh];
            break;

        case 3:
            [waitingReceivingOrderVC.tableView startHeadRefresh];
            break;
            
//        case 4:
//            [finishOrderVC.tableView startHeadRefresh];

            break;
            
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint endpoint = scrollView.contentOffset;
    NSInteger index = round(endpoint.x/kScreenWidth);
    segmentedView.selectedSegmentIndex = index;
    
    [self segmentedView:segmentedView buttonClick:index];
}

#pragma mark - WJRefundPickerView
-(void)refundPickerView:(WJRefundPickerView *)refundPickerView clickCancelButton:(UIButton *)cancelButton
{
    [_maskView removeFromSuperview];
    
}

-(void)refundPickerView:(WJRefundPickerView *)refundPickerView clickConfirmButtonWithLogisticsCompanyModel:(WJLogisticsCompanyModel *)logisticsCompanyModel
{
    [_maskView removeFromSuperview];
    
    self.cancelOrderManager.orderStatus = self.orderModel.orderStatus;
    self.cancelOrderManager.orderId     = self.orderModel.orderNo;
    self.cancelOrderManager.reason = logisticsCompanyModel.logisticsCompanyName;
    [self.cancelOrderManager loadData];
}

#pragma mark - WJSystemAlertViewDelegate
-(void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    } else {
        
        self.confirmReceiveManager.orderId = self.orderModel.orderNo;
        [self.confirmReceiveManager loadData];
        
    }
}

#pragma mark - WJMyOrderControllerDelegate

-(void)payRightNowWithOrder:(WJOrderModel *)order
{
    NSLog(@"立即付款");
    [self showLoadingView];
    self.payRightManager.orderId = order.orderNo;
    self.payRightManager.orderTotal = order.PayAmount;
    [self.payRightManager loadData];
}

-(void)checkLogisticseWithOrder:(WJOrderModel *)order
{
    NSLog(@"检查物流");
    WJLogisticsDetailViewController *logisticsDetailVC = [[WJLogisticsDetailViewController alloc] init];
    logisticsDetailVC.orderId = order.orderNo;
    [self.navigationController pushViewController:logisticsDetailVC animated:YES];
}

-(void)ConfirmReceiveWithOrder:(WJOrderModel *)order
{
    NSLog(@"确认收货");
    self.orderModel  = order;

    WJSystemAlertView *alertView = [[WJSystemAlertView alloc] initWithTitle:@"提示" message:@"是否确认收货？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是" textAlignment:NSTextAlignmentCenter];
    
    [alertView showIn];
}

-(void)CheckMoreWithOrder:(WJOrderModel *)order
{
    NSLog(@"查看更多");
    WJOrderDetailController *orderDetailVC = [[WJOrderDetailController alloc] init];
    orderDetailVC.orderId = order.orderNo;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

-(void)cancelOrderWithOrder:(WJOrderModel *)order
{
    NSLog(@"取消订单");
    self.orderModel  = order;
    [self.view addSubview:self.maskView];
    [self.maskView addSubview:self.refundPickerView];
}

-(void)scrollWaitPay
{
    [self segmentedView:segmentedView buttonClick:1];
}

#pragma mark- Event Response
-(void)tapMaskViewgesture:(UITapGestureRecognizer*)tap
{
    [tap.view removeFromSuperview];
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

-(APICancelOrderManager *)cancelOrderManager
{
    if (_cancelOrderManager == nil) {
        _cancelOrderManager = [[APICancelOrderManager alloc] init];
        _cancelOrderManager.delegate = self;
    }
    _cancelOrderManager.userId = USER_ID;
    return _cancelOrderManager;
}

-(APIConfirmReceiveManager *)confirmReceiveManager
{
    if (_confirmReceiveManager == nil) {
        _confirmReceiveManager = [[APIConfirmReceiveManager alloc] init];
        _confirmReceiveManager.delegate = self;
    }
    return _confirmReceiveManager;
}

-(APIPayManager *)payRightManager
{
    if (_payRightManager == nil) {
        _payRightManager = [[APIPayManager alloc] init];
        _payRightManager.delegate = self;
    }
    return _payRightManager;
}
@end
