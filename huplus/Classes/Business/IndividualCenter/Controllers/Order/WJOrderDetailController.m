//
//  WJOrderDetailController.m
//  HuPlus
//
//  Created by reborn on 16/12/28.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJOrderDetailController.h"
#import "WJOrderDetailCell.h"
#import "WJOrderDetailModel.h"
#import "WJAfterSalesApplicationController.h"
#import "WJSystemAlertView.h"
#import "WJOrderDetailSectionView.h"
#import "APIOrderDetailManager.h"
#import "WJOrderDetailReformer.h"
#import "WJThirdShopViewController.h"
#import "WJProductDetailController.h"
#import "APICancelOrderManager.h"
#import "APIConfirmReceiveManager.h"
#import "APIPayManager.h"
#import "WJPaymentModel.h"
#import "WJSelectPaymentViewController.h"
#import "WJRefundPickerView.h"
#import "WJLogisticsDetailViewController.h"
#import "APIDeleteOrderManager.h"
#import "WJApplyRefundListController.h"
#import "WJThirdShopDetailViewController.h"


#define kOrderCellIdentifier     @"kOrderCellIdentifier"
@interface WJOrderDetailController ()<UITableViewDelegate, UITableViewDataSource,WJSystemAlertViewDelegate,WJMyOrderControllerDelegate,APIManagerCallBackDelegate,WJRefundPickerViewDelegate>
{
    NSTimer     *remainTimer;
    NSInteger   countDown;
    UILabel     *timeRemaindL;
    UILabel     *timeL;
    UIView      *bottomView;
}
@property(nonatomic,strong)UITableView                  *tableView;
@property(nonatomic,strong)APIOrderDetailManager        *orderDetailManager;
@property(nonatomic,strong)APICancelOrderManager        *cancelOrderManager;
@property(nonatomic,strong)APIConfirmReceiveManager     *confirmReceiveManager;
@property(nonatomic,strong)APIDeleteOrderManager        *deleteOrderManager;
@property(nonatomic,strong)APIPayManager                *payRightManager;     //立即付款
@property(nonatomic,strong)WJOrderDetailModel           *detailOrder;
@property(nonatomic,strong)WJRefundPickerView           *refundPickerView;
@property(nonatomic,strong)UIView                       *maskView;

@end

@implementation WJOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    // Do any additional setup after loading the view.
    self.isHiddenTabBar = YES;
    self.isHiddenNavLine = NO;
    countDown = 0;
    
    [self.view addSubview:self.tableView];
    
    [kDefaultCenter addObserver:self selector:@selector(requestData) name:@"paySuccessRefresh" object:nil];

    [self showLoadingView];
    [self requestData];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)requestData
{
    [self.orderDetailManager loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBottomView
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kNavigationBarHeight - ALD(64), kScreenWidth, ALD(64))];
    
    bottomView.backgroundColor = WJColorTabBar;
    bottomView.layer.borderWidth = 0.5f;
    bottomView.layer.borderColor =  WJColorSeparatorLine.CGColor;
    
    if (self.detailOrder.orderStatus == OrderStatusUnfinished) {
        
        UIButton *payRigthNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        payRigthNowButton.frame = CGRectMake(bottomView.width - ALD(10) - ALD(80), ALD(10), ALD(80), ALD(30));
        [payRigthNowButton setTitle:@"立即付款"
                           forState:UIControlStateNormal];
        [payRigthNowButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        payRigthNowButton.layer.cornerRadius = 4;
        payRigthNowButton.layer.borderColor = WJColorNavigationBar.CGColor;
        payRigthNowButton.layer.borderWidth = 0.5f;
        payRigthNowButton.titleLabel.font = WJFont14;
        [payRigthNowButton addTarget:self action:@selector(payRigthNowButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:payRigthNowButton];
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(bottomView.width - ALD(20) - ALD(160), ALD(10), ALD(80), ALD(30));
        [cancelButton setTitle:@"取消订单"
                      forState:UIControlStateNormal];
        [cancelButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        cancelButton.layer.cornerRadius = 4;
        cancelButton.layer.borderColor = WJColorNavigationBar.CGColor;
        cancelButton.layer.borderWidth = 0.5f;
        cancelButton.titleLabel.font = WJFont14;
        [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:cancelButton];
        
        timeRemaindL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(5), ALD(100), ALD(20))];
        timeRemaindL.textColor = WJColorDardGray6;
        timeRemaindL.font = WJFont12;
        timeRemaindL.hidden = YES;
        timeRemaindL.text = @"付款剩余时间";
        [bottomView addSubview:timeRemaindL];
        
        timeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), timeRemaindL.bottom, ALD(100), ALD(20))];
        timeL.textColor = WJColorNavigationBar;
        timeL.font = WJFont14;
        timeL.hidden = YES;
        [bottomView addSubview:timeL];
        
    } else if (self.detailOrder.orderStatus == OrderStatusSuccess) {
        
        UIButton *refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        refundButton.frame = CGRectMake(bottomView.width - ALD(10) - ALD(80), ALD(10), ALD(80), ALD(30));
        [refundButton setTitle:@"退货/退款"
                      forState:UIControlStateNormal];
        [refundButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        refundButton.layer.cornerRadius = 4;
        refundButton.layer.borderColor = WJColorNavigationBar.CGColor;
        refundButton.layer.borderWidth = 0.5f;
        refundButton.titleLabel.font = WJFont14;
        [refundButton addTarget:self action:@selector(refundButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:refundButton];
        
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(bottomView.width - ALD(20) - ALD(160), ALD(10), ALD(80), ALD(30));
        [deleteButton setTitle:@"删除订单"
                      forState:UIControlStateNormal];
        [deleteButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        deleteButton.layer.cornerRadius = 4;
        deleteButton.layer.borderColor = WJColorNavigationBar.CGColor;
        deleteButton.layer.borderWidth = 0.5f;
        deleteButton.titleLabel.font = WJFont14;
        [deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:deleteButton];
        
    } else if (self.detailOrder.orderStatus == OrderStatusWaitReceive) {
        
        UIButton *logisticsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        logisticsButton.frame = CGRectMake(bottomView.width - ALD(10) - ALD(80), ALD(10), ALD(80), ALD(30));
        [logisticsButton setTitle:@"查看物流"
                         forState:UIControlStateNormal];
        [logisticsButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        logisticsButton.layer.cornerRadius = 4;
        logisticsButton.layer.borderColor = WJColorNavigationBar.CGColor;
        logisticsButton.layer.borderWidth = 0.5f;
        logisticsButton.titleLabel.font = WJFont14;
        [logisticsButton addTarget:self action:@selector(logisticsButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:logisticsButton];
        
        
        UIButton *confirmReceiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmReceiveButton.frame = CGRectMake(bottomView.width - ALD(20) - ALD(160), ALD(10), ALD(80), ALD(30));
        [confirmReceiveButton setTitle:@"确认收货"
                              forState:UIControlStateNormal];
        [confirmReceiveButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        confirmReceiveButton.layer.cornerRadius = 4;
        confirmReceiveButton.layer.borderColor = WJColorNavigationBar.CGColor;
        confirmReceiveButton.layer.borderWidth = 0.5f;
        confirmReceiveButton.titleLabel.font = WJFont14;
        [confirmReceiveButton addTarget:self action:@selector(confirmReceiveButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:confirmReceiveButton];
        
    } else if (self.detailOrder.orderStatus == OrderStatusWaitDeliver) {

        UIButton *refundOnlyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        refundOnlyButton.frame = CGRectMake(bottomView.width - ALD(10) - ALD(80), ALD(10), ALD(80), ALD(30));
        [refundOnlyButton setTitle:@"申请退款"
                      forState:UIControlStateNormal];
        [refundOnlyButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        refundOnlyButton.layer.cornerRadius = 4;
        refundOnlyButton.layer.borderColor = WJColorNavigationBar.CGColor;
        refundOnlyButton.layer.borderWidth = 0.5f;
        refundOnlyButton.titleLabel.font = WJFont14;
        [refundOnlyButton addTarget:self action:@selector(refundOnlyButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:refundOnlyButton];
        
    } else if (self.detailOrder.orderStatus == OrderStatusClose) {
        
        bottomView.hidden = YES;

    }
    
    [self.view addSubview:bottomView];
    
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    if ([manager isKindOfClass:[APIOrderDetailManager class]]) {
        
        self.detailOrder  = [manager fetchDataWithReformer:[[WJOrderDetailReformer alloc] init]];
        countDown = self.detailOrder.countDown;
        [self initBottomView];
        [self changeBottomView];
        
        [self.tableView reloadData];
        
    } else if ([manager isKindOfClass:[APICancelOrderManager class]]) {
        
        [self updateOrderStatus:OrderStatusClose];
        bottomView.hidden = YES;

    } else if ([manager isKindOfClass:[APIConfirmReceiveManager class]])  {
        
        [self updateOrderStatus:OrderStatusSuccess];
        bottomView.hidden = YES;
        [self.tableView reloadData];

    } else if ([manager isKindOfClass:[APIDeleteOrderManager class]]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        [self hiddenLoadingView];
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        WJPaymentModel *paymentModel = [[WJPaymentModel alloc] initWithDic:dic];
        
        WJSelectPaymentViewController *selectPaymentVC = [[WJSelectPaymentViewController alloc] init];
        selectPaymentVC.paymentModel = paymentModel;
        [self.navigationController pushViewController:selectPaymentVC animated:YES whetherJump:YES];
        
    }
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3 + self.detailOrder.orderStoreListArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
        
    } else if (section == 2 + self.detailOrder.orderStoreListArray.count) {
        
        return 1;

    } else {
        
        WJOrderStoreModel *orderStoreModel = self.detailOrder.orderStoreListArray[section - 2];

        if (orderStoreModel.productList == nil || orderStoreModel.productList.count == 0) {
            return 0;
            
        } else {
            return orderStoreModel.productList.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return 0;
    } else if (section == 2 + self.detailOrder.orderStoreListArray.count) {
        return 0;
    } else {
        return ALD(44);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2 + self.detailOrder.orderStoreListArray.count) {
        return 0;
    }
    return ALD(15);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *viewIdentfier = @"headView";
    
    WJOrderDetailSectionView *sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
    
    if(!sectionHeadView){
        
        sectionHeadView = [[WJOrderDetailSectionView alloc] initWithReuseIdentifier:viewIdentfier];
    }
    
    WJOrderStoreModel *orderStoreModel = self.detailOrder.orderStoreListArray[section - 2];
    [sectionHeadView configDataWithDetailModel:orderStoreModel];
    
    __weak typeof(self) weakSelf = self;
    sectionHeadView.tapShopBlock = ^{
        
        __strong typeof(self) strongSelf = weakSelf;

        WJThirdShopDetailViewController *thirdShopVC = [[WJThirdShopDetailViewController alloc] init];
        thirdShopVC.shopId = orderStoreModel.shopId;
        [strongSelf.navigationController pushViewController:thirdShopVC animated:NO];
    };
    
    return sectionHeadView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger section = indexPath.section;
    
    if (section == 0) {
        return ALD(44);
    } else if (section == 1) {
        return ALD(80);
    } else if (section == 2 + self.detailOrder.orderStoreListArray.count) {
        return ALD(148);
    } else {
        return ALD(140);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    for (UIView *subView in cell.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        
        UILabel *orderNoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(10), ALD(250), ALD(20))];
        orderNoL.text = [NSString stringWithFormat:@"订单编号：%@",self.detailOrder.orderNo];
        orderNoL.textColor = WJColorNavigationBar;
        orderNoL.font = WJFont12;
        [cell.contentView addSubview:orderNoL];
        
        UILabel *orderStatusL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(70), ALD(10), ALD(70), ALD(20))];
        orderStatusL.textAlignment = NSTextAlignmentRight;
        orderStatusL.textColor = WJColorNavigationBar;
        orderStatusL.font = WJFont12;
        [cell.contentView addSubview:orderStatusL];
        
        switch (self.detailOrder.orderStatus) {
            case OrderStatusSuccess:
            {
                orderStatusL.text = @"已完成";
            }
                break;
                
            case OrderStatusUnfinished:
            {
                orderStatusL.text = @"待支付";
            }
                break;
                
            case OrderStatusWaitReceive:
            {
                orderStatusL.text = @"卖家已发货";
            }
                break;
                
            case OrderStatusWaitDeliver:
            {
                orderStatusL.text = @"待发货";
            }
                break;
                
            case OrderStatusClose:
            {
                orderStatusL.text = @"已关闭";
            }
                break;
                
            default:
                break;
        }

        
    } else if (section == 1) {
        
        UIImageView *pinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), (ALD(80) - ALD(16))/2, ALD(16), ALD(16))];
        pinImageView.image = [UIImage imageNamed:@"address_icon_img"];
        [cell.contentView addSubview:pinImageView];
        
        UILabel *receiverL = [[UILabel alloc] initWithFrame:CGRectMake(pinImageView.right + ALD(15), ALD(15), ALD(130), ALD(20))];
        receiverL.text = [NSString stringWithFormat:@"收货人：%@",self.detailOrder.receiverName];
        receiverL.font = WJFont13;
        receiverL.textColor = WJColorNavigationBar;
        [cell.contentView addSubview:receiverL];
        
        UILabel *phoneL = [[UILabel alloc] initWithFrame:CGRectMake(receiverL.right + ALD(40), ALD(15), ALD(100), ALD(20))];
        phoneL.textColor = WJColorNavigationBar;
        phoneL.text = [NSString stringWithFormat:@"%@",self.detailOrder.phoneNumber];
        phoneL.font = WJFont13;
        [cell.contentView addSubview:phoneL];
        
        
        UILabel *addressL = [[UILabel alloc] initWithFrame:CGRectMake(receiverL.frame.origin.x, receiverL.bottom + ALD(10), kScreenWidth - ALD(45), ALD(20))];
        addressL.text = [NSString stringWithFormat:@"收货地址：%@",self.detailOrder.address];
        addressL.textColor = WJColorLightGray;
        addressL.font = WJFont13;
        [cell.contentView addSubview:addressL];
        
    } else if (section == 2 + self.detailOrder.orderStoreListArray.count) {
        
        UILabel *amountTitleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(15), ALD(70), ALD(20))];
        amountTitleL.textColor = WJColorNavigationBar;
        amountTitleL.text = @"商品金额";
        amountTitleL.font = WJFont15;
        [cell.contentView addSubview:amountTitleL];
        
        UILabel *couponTitleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), amountTitleL.bottom + ALD(10), ALD(60), ALD(20))];
        couponTitleL.text = @"优惠券";
        couponTitleL.textColor = WJColorNavigationBar;
        couponTitleL.font = WJFont13;
        [cell.contentView addSubview:couponTitleL];
        
        UILabel *freightTitleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), couponTitleL.bottom + ALD(10), ALD(60), ALD(20))];
        freightTitleL.text = @"运费";
        freightTitleL.textColor = WJColorNavigationBar;
        freightTitleL.font = WJFont13;
        [cell.contentView addSubview:freightTitleL];
        
        
        UILabel *paymentTitleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), freightTitleL.bottom + ALD(10), ALD(60), ALD(20))];
        paymentTitleL.text = @"实付款";
        paymentTitleL.textColor = WJColorNavigationBar;
        paymentTitleL.font = WJFont13;
        [cell.contentView addSubview:paymentTitleL];
        
        UILabel *amountL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(100), ALD(15), ALD(100), ALD(20))];
        amountL.textColor = WJColorNavigationBar;
        amountL.text = [NSString stringWithFormat:@"¥%@",self.detailOrder.amount];
        amountL.font = WJFont15;
        amountL.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:amountL];
        
        
        UILabel *couponL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(100), amountL.bottom + ALD(10), ALD(100), ALD(20))];
        couponL.textColor = WJColorNavigationBar;
        couponL.text = [NSString stringWithFormat:@"- %@",self.detailOrder.specialAmount];
        couponL.font = WJFont15;
        couponL.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:couponL];
        
        
        UILabel *freightL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(100), couponL.bottom + ALD(10), ALD(100), ALD(20))];
        freightL.textColor = WJColorNavigationBar;
        freightL.text = [NSString stringWithFormat:@"+ %@",self.detailOrder.freightAmount];
        freightL.font = WJFont15;
        freightL.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:freightL];
        
        UILabel *paymentL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(100), freightL.bottom + ALD(10), ALD(100), ALD(20))];
        paymentL.textColor = WJColorNavigationBar;
        paymentL.text = [NSString stringWithFormat:@"+ %@",self.detailOrder.PayAmount];
        paymentL.textAlignment = NSTextAlignmentRight;
        paymentL.font = WJFont15;
        [cell.contentView addSubview:paymentL];
        
        
        UILabel *orderTimeL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - ALD(200), paymentL.bottom, ALD(200), ALD(20))];
        orderTimeL.text = [NSString stringWithFormat:@"下单时间：%@",self.detailOrder.createTime];

        orderTimeL.textColor = WJColorLightGray;
        orderTimeL.font = WJFont12;
        orderTimeL.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:orderTimeL];
        
    }  else {
        
        WJOrderDetailCell *ordercCell = [[WJOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kOrderCellIdentifier];
        ordercCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell  = ordercCell;
        
        WJOrderStoreModel *orderStoreModel = self.detailOrder.orderStoreListArray[indexPath.section - 2];
        [ordercCell configDataWithProduct:orderStoreModel.productList[indexPath.row]];
        
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= 2 && !(indexPath.section == 2 + self.detailOrder.orderStoreListArray.count)) {
        
        WJOrderStoreModel *orderStoreModel = self.detailOrder.orderStoreListArray[indexPath.section - 2];
        WJProductModel *productModel = orderStoreModel.productList[indexPath.row];
        
        WJProductDetailController * productDetailVC = [[WJProductDetailController alloc]init];
        productDetailVC.productId = productModel.productId;
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }
}


#pragma mark - WJRefundPickerViewDelegate

-(void)refundPickerView:(WJRefundPickerView *)refundPickerView clickCancelButton:(UIButton *)cancelButton
{
    [_maskView removeFromSuperview];
}

-(void)refundPickerView:(WJRefundPickerView *)refundPickerView clickConfirmButtonWithLogisticsCompanyModel:(WJLogisticsCompanyModel *)logisticsCompanyModel
{
    [_maskView removeFromSuperview];
    
    self.cancelOrderManager.reason = logisticsCompanyModel.logisticsCompanyName;
    [self showLoadingView];
    [self.cancelOrderManager loadData];
}

#pragma mark - WJSystemAlertViewDelegate
-(void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    } else {
        
        [self showLoadingView];
        [self.deleteOrderManager loadData];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark - Action
-(void)payRigthNowButtonAction
{
    //立即付款
    [self showLoadingView];
    self.payRightManager.orderId = self.detailOrder.orderNo;
    self.payRightManager.orderTotal = self.detailOrder.PayAmount;
    [self.payRightManager loadData];
}

-(void)refundButtonAction
{
    //退货
    WJAfterSalesApplicationController *afterSalesApplicationVC = [[WJAfterSalesApplicationController alloc] init];
    afterSalesApplicationVC.detailOrder = self.detailOrder;
    [self.navigationController pushViewController:afterSalesApplicationVC animated:YES];
}

-(void)refundOnlyButtonAction
{
    //仅退款
    WJApplyRefundListController *applyRefundListVC = [[WJApplyRefundListController alloc] init];
    applyRefundListVC.detailOrder = self.detailOrder;
    [self.navigationController pushViewController:applyRefundListVC animated:YES];
}

-(void)deleteButtonAction
{
    WJSystemAlertView *alertView = [[WJSystemAlertView alloc] initWithTitle:@"确认删除此订单吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除" textAlignment:NSTextAlignmentCenter];
    alertView.tag = 1001;
    [alertView showIn];

}

-(void)logisticsButtonAction
{
    //查看物流
    WJLogisticsDetailViewController *logisticsDetailVC = [[WJLogisticsDetailViewController alloc] init];
    logisticsDetailVC.orderId = self.detailOrder.orderNo;
    [self.navigationController pushViewController:logisticsDetailVC animated:YES];
}

-(void)confirmReceiveButtonAction
{
    //确认收货
    [self.confirmReceiveManager loadData];
}

-(void)cancelButtonAction
{
    [self.view addSubview:self.maskView];
    [self.maskView addSubview:self.refundPickerView];
}

#pragma mark- Event Response
-(void)tapMaskViewgesture:(UITapGestureRecognizer*)tap
{
    [tap.view removeFromSuperview];
}

- (void)changeCountdown
{
    countDown --;
    NSString *time = [self TimeformatFromSeconds:countDown];
    timeL.text = [NSString stringWithFormat:@"%@",time];
    
    if (countDown <= 0) {
        timeRemaindL.hidden = YES;
        timeL.hidden = YES;
        bottomView.hidden = YES;
        [remainTimer invalidate];
        remainTimer = nil;
    
        [self updateOrderStatus:OrderStatusClose];
    }
}

//更改订单状态
- (void)updateOrderStatus:(OrderStatus)status
{
    self.detailOrder.orderStatus = status;
    
    [self.tableView reloadData];
}

-(void)changeBottomView
{
    if (self.detailOrder.orderStatus == OrderStatusUnfinished) {
        
        if (countDown > 0) {
            
            timeRemaindL.hidden = NO;
            timeL.hidden = NO;
            NSString *time = [self TimeformatFromSeconds:countDown];
            timeL.text = [NSString stringWithFormat:@"%@",time];
            
            remainTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeCountdown) userInfo:nil repeats:YES];
            
        } else {
            
            timeRemaindL.hidden = YES;
            timeL.hidden = YES;
            bottomView.hidden = YES;
            [remainTimer invalidate];
            remainTimer = nil;
            [self updateOrderStatus:OrderStatusClose];
        }
    }
    
}

-(NSString*)TimeformatFromSeconds:(NSInteger)seconds
{
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}

#pragma mark - setter& getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - ALD(64)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
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

-(APIOrderDetailManager *)orderDetailManager
{
    if (_orderDetailManager == nil) {
        _orderDetailManager = [[APIOrderDetailManager alloc] init];
        _orderDetailManager.delegate = self;
    }
    _orderDetailManager.userId = USER_ID;
    _orderDetailManager.orderId = self.orderId;
    return _orderDetailManager;
}

-(APICancelOrderManager *)cancelOrderManager
{
    if (_cancelOrderManager == nil) {
        _cancelOrderManager = [[APICancelOrderManager alloc] init];
        _cancelOrderManager.delegate = self;
    }
    _cancelOrderManager.userId = USER_ID;
    _cancelOrderManager.orderId = self.detailOrder.orderNo;
    _cancelOrderManager.orderStatus =  self.detailOrder.orderStatus;
    return _cancelOrderManager;
}

-(APIDeleteOrderManager *)deleteOrderManager
{
    if (_deleteOrderManager == nil) {
        _deleteOrderManager = [[APIDeleteOrderManager alloc] init];
        _deleteOrderManager.delegate = self;
    }
    _deleteOrderManager.userId = USER_ID;
    _deleteOrderManager.orderId = self.detailOrder.orderNo;
    return _deleteOrderManager;
}

-(APIConfirmReceiveManager *)confirmReceiveManager
{
    if (_confirmReceiveManager == nil) {
        _confirmReceiveManager = [[APIConfirmReceiveManager alloc] init];
        _confirmReceiveManager.delegate = self;
    }
    _confirmReceiveManager.orderId = self.detailOrder.orderNo;
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
