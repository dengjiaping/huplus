//
//  WJOrderConfirmController.m
//  HuPlus
//
//  Created by reborn on 17/1/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJOrderConfirmController.h"
#import "WJOrderDetailCell.h"
#import "WJMyCouponViewController.h"
#import "WJSelectPaymentViewController.h"
#import "WJOrderConfirmModel.h"
#import "WJOrderShopModel.h"
#import "WJOrderConfirmCell.h"
#import "WJInvoiceViewController.h"
#import "WJMyDeliveryAddressViewController.h"
#import "APIShopCartSettleManager.h"
#import "WJConfirmOrderReformer.h"
#import "APISubmitOrderManager.h"
#import "WJPaymentModel.h"
#import "APIPayRightNowManager.h"
#define kOrderCellIdentifier   @"kOrderCellIdentifier"
#define kCustomCellIdentifier  @"kCustomCellIdentifier"

@interface WJOrderConfirmController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,APIManagerCallBackDelegate>
{
    UILabel    *nameL;
    UILabel    *phoneL;
    UILabel    *addressL;
    
    UILabel    *totalAmountL;
//    UILabel    *couponL;

    CGFloat    totalOrderAmount;
}
@property(nonatomic,strong)APIShopCartSettleManager *shopCartSettleManager; //购物车结算
@property(nonatomic,strong)APISubmitOrderManager    *submitOrderManager;    //创建订单
@property(nonatomic,strong)WJOrderConfirmModel      *orderConfirmModel;

@property(nonatomic,strong)UITableView              *tableView;
@property(nonatomic,strong)NSArray                  *listArray;

@end

@implementation WJOrderConfirmController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    totalOrderAmount = 0;
    self.isHiddenTabBar = YES;
    
    [self.view addSubview:self.tableView];
    [self initBottomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"refreshMyDeliveryAddress" object:nil];

    [self requestData];
}

-(void)requestData
{
    if (self.orderConfirmFromController == FromPayRightNow) {
        
        //立即购买
        [self showLoadingView];
        [self.payRightNowManager loadData];
        
    } else {
        
        //购物车
        [self showLoadingView];
        [self.shopCartSettleManager loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBottomView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight - ALD(49) - kNavBarAndStatBarHeight, kScreenWidth, ALD(49))];
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = WJColorSeparatorLine.CGColor;
    bgView.backgroundColor = WJColorTabBar;
    [self.view addSubview:bgView];
    
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(kScreenWidth - ALD(130), 0, ALD(130), bgView.height);
    submitButton.backgroundColor = WJColorMainRed;
    [submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    submitButton.titleLabel.font = WJFont16;
    submitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:submitButton];
    
    
    totalAmountL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - submitButton.width - ALD(15) - ALD(170), (ALD(49) - ALD(25))/2, ALD(170), ALD(25))];
    totalAmountL.text = [NSString stringWithFormat:@"合计: ¥%.2f",totalOrderAmount];
    totalAmountL.textColor = WJColorNavigationBar;
    totalAmountL.font = WJFont15;
    totalAmountL.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:totalAmountL];
    
//    couponL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - submitButton.width - ALD(15) - ALD(170), totalAmountL.bottom, ALD(170), ALD(15))];
//    couponL.text = [NSString stringWithFormat:@"(优惠券抵扣%@元)",self.orderConfirmModel.couponAmount];
//    couponL.textColor = WJColorNavigationBar;
//    couponL.font = WJFont12;
//    couponL.textAlignment = NSTextAlignmentRight;
//    [bgView addSubview:couponL];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIShopCartSettleManager class]]) {
        [self hiddenLoadingView];
        self.orderConfirmModel = [manager fetchDataWithReformer:[[WJConfirmOrderReformer alloc] init]];
        [self refreshBottomView];
        [self.tableView reloadData];
        
    } else if ([manager isKindOfClass:[APIPayRightNowManager class]]) {
        
        [self hiddenLoadingView];
        self.orderConfirmModel = [manager fetchDataWithReformer:[[WJConfirmOrderReformer alloc] init]];
        [self refreshBottomView];
        [self.tableView reloadData];
        
    } else if ([manager isKindOfClass:[APISubmitOrderManager class]]) {
        
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.orderConfirmModel.shopArray.count == 0 || self.orderConfirmModel.shopArray == nil) {
        
        return 0;
    } else {
        
        return self.orderConfirmModel.shopArray.count + 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
        
    } else if (section == self.orderConfirmModel.shopArray.count + 1) {
        
        return 1;
        
    } else {
        
        WJOrderShopModel *orderShopModel = self.orderConfirmModel.shopArray[section - 1];
        return orderShopModel.productArray.count + 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return ALD(110);
        
    } else {
        
        WJOrderShopModel *orderShopModel = self.orderConfirmModel.shopArray[indexPath.section - 1];
        
        if (indexPath.row < orderShopModel.productArray.count) {
            
            return ALD(140);
        } else {
            return ALD(44);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        
        return 0;
        
    } else {
        
        return ALD(44);
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.orderConfirmModel.shopArray.count) {
        return 0;
    } else {
        return ALD(15);
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    
    if (!(section == 0) && !(section == self.orderConfirmModel.shopArray.count + 1)) {

        headerView = [UIView new];
        headerView.backgroundColor = WJColorWhite;
        
        UIImage *shopImage = [UIImage imageNamed:@"shopIcon"];
        UIImageView *merchantIconView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), (ALD(44) - shopImage.size.height)/2, shopImage.size.width, shopImage.size.height)];
        merchantIconView.image = shopImage;
        [headerView addSubview:merchantIconView];
        
        
        UILabel *shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(merchantIconView.right + ALD(10), (ALD(44) - ALD(20))/2, ALD(150), ALD(20))];
        shopNameL.textColor = WJColorBlack;
        shopNameL.font = WJFont12;
        shopNameL.textAlignment = NSTextAlignmentLeft;
        WJOrderShopModel *orderShopModel = self.orderConfirmModel.shopArray[section - 1];
        shopNameL.text = orderShopModel.shopName;
        [headerView addSubview:shopNameL];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(43), kScreenWidth, ALD(1))];
        lineView.backgroundColor = WJColorSeparatorLine;
        [headerView addSubview:lineView];
        
        
        return headerView;
    }
    
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorWhite;
    }
    
    for (UIView *subView in cell.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    if (indexPath.section == 0) {
        
        if (([self.orderConfirmModel.receiverName isEqualToString:@""] || self.orderConfirmModel.receiverName == nil) && ([self.orderConfirmModel.phoneNumber isEqualToString:@""] || self.orderConfirmModel.phoneNumber == nil) && ([self.orderConfirmModel.address isEqualToString:@""] || self.orderConfirmModel.address == nil)) {
            
            UILabel *noAddessTipL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), (ALD(100) - ALD(20))/2, kScreenWidth - ALD(10), ALD(10))];
            noAddessTipL.textColor = WJColorDardGray9;
            noAddessTipL.font = WJFont14;
            noAddessTipL.text = @"请填写收货地址";
            [cell.contentView addSubview:noAddessTipL];
            
        } else {
            
            nameL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(10), kScreenWidth - ALD(20), ALD(20))];
            nameL.textColor = WJColorNavigationBar;
            nameL.text = [NSString stringWithFormat:@"收件人:%@",self.orderConfirmModel.receiverName];
            nameL.font = WJFont14;
            [cell.contentView addSubview:nameL];
            
            
            phoneL = [[UILabel alloc] initWithFrame:CGRectMake(nameL.frame.origin.x, nameL.bottom + ALD(5), kScreenWidth - ALD(20), ALD(20))];
            phoneL.textColor = WJColorNavigationBar;
            phoneL.text = [NSString stringWithFormat:@"手机号: %@",self.orderConfirmModel.phoneNumber];
            phoneL.font = WJFont14;
            [cell.contentView addSubview:phoneL];
            
            
            addressL = [[UILabel alloc] initWithFrame:CGRectMake(phoneL.frame.origin.x,phoneL.bottom + ALD(5), kScreenWidth - ALD(25), ALD(40))];
            addressL.textColor = WJColorNavigationBar;
            addressL.numberOfLines = 0;
            addressL.text = [NSString stringWithFormat:@"收货地址:%@",self.orderConfirmModel.address];
            addressL.font = WJFont14;
            [cell.contentView addSubview:addressL];
        }

        UIImage *image = [UIImage imageNamed:@"icon_arrow_right"];
        UIImageView *rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - image.size.width, (ALD(100) - image.size.height)/2, image.size.width, image.size.height)];
        rightArrowImageView.image = [UIImage imageNamed:@"icon_arrow_right"];
        [cell.contentView  addSubview:rightArrowImageView];
        
    } else {
        
        WJOrderShopModel *orderShopModel = self.orderConfirmModel.shopArray[indexPath.section - 1];
        
        if (indexPath.row < orderShopModel.productArray.count) {
            
            WJOrderDetailCell *ordercCell = [[WJOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kOrderCellIdentifier];
            ordercCell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell  = ordercCell;
            
            [ordercCell configDataWithProduct:orderShopModel.productArray[indexPath.row]];
            
        } else {
            
            
            if (indexPath.row == orderShopModel.productArray.count) {
                
                
                WJOrderConfirmCell *orderConfirmCell = [[WJOrderConfirmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellIdentifier];
                orderConfirmCell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell  = orderConfirmCell;
                orderConfirmCell.isShowRightArrow = NO;
                
                WJOrderShopModel *orderShopModel = self.orderConfirmModel.shopArray[indexPath.section - 1];
                
                NSDictionary *dic = [self.listArray objectAtIndex:0];
                
                if ([orderShopModel.deliverFee floatValue] > 0) {
                    
                    [orderConfirmCell configDataWithName:dic[@"name"] Content:[NSString stringWithFormat:@" ¥%@",orderShopModel.deliverFee]];
                    
                } else {
                    
                    [orderConfirmCell configDataWithName:dic[@"name"] Content:dic[@"text"]];
                }
                
                
            } else if (indexPath.row == orderShopModel.productArray.count + 1) {
                
                WJOrderConfirmCell *couponCell = [[WJOrderConfirmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"couponCellIdentifier"];
                couponCell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell  = couponCell;
                NSDictionary *dic = [self.listArray objectAtIndex:1];
                if ([self.orderConfirmModel.couponAmount floatValue] > 0) {
                    
                    [couponCell configDataWithName:dic[@"name"] Content:[NSString stringWithFormat:@"%@元%@",self.orderConfirmModel.couponAmount,self.orderConfirmModel.couponName]];
                    couponCell.isShowRightArrow = YES;
                    
                } else {
                    
                    [couponCell configDataWithName:dic[@"name"] Content:dic[@"text"]];
                    couponCell.isShowRightArrow = NO;

                }
                
                
            } else {
                
                UILabel *amountL = [[UILabel alloc] initWithFrame:CGRectZero];
                amountL.font = WJFont14;
                amountL.textColor = WJColorDardGray9;

                NSInteger totalCount = 0;
                CGFloat  totalAmount = 0;
                totalAmount += [orderShopModel.deliverFee floatValue];
                for (WJProductModel *product in orderShopModel.productArray) {
                    
                    totalCount += product.count;
                    totalAmount += [product.salePrice floatValue] *product.count;
                    
                }
                amountL.text = [NSString stringWithFormat:@"小计: ¥%.2f",totalAmount];
                
                CGSize txtSize = [amountL.text sizeWithAttributes:@{NSFontAttributeName:WJFont14} constrainedToSize:CGSizeMake(1000000, ALD(20))];
                
                amountL.frame = CGRectMake(kScreenWidth - ALD(12) - txtSize.width, (ALD(44) - ALD(20))/2, ALD(100), ALD(20));

                [cell.contentView addSubview:amountL];
                
                UILabel *totalCountL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - amountL.width - ALD(10) - ALD(80), (ALD(44) - ALD(20))/2, ALD(80), ALD(20))];
                totalCountL.font = WJFont14;
                totalCountL.textColor = WJColorDardGray9;
                totalCountL.text = [NSString stringWithFormat:@"共%ld件商品",totalCount];
                [cell.contentView addSubview:totalCountL];
                
            }
            
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        WJMyDeliveryAddressViewController *myDeliveryAddressVC = [[WJMyDeliveryAddressViewController alloc] init];
        myDeliveryAddressVC.fromVC = fromOrderConfirmVC;
        
        myDeliveryAddressVC.selectAddressBlock = ^(WJDeliveryAddressModel *addressModel){
            
            self.orderConfirmModel.receiverName =  addressModel.name;
            self.orderConfirmModel.phoneNumber = addressModel.phone;
            self.orderConfirmModel.address = addressModel.address;
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
            if (self.orderConfirmFromController == FromPayRightNow) {
                
                //立即购买
                WJOrderShopModel *orderShopModel = [self.orderConfirmModel.shopArray objectAtIndex:0];
                WJProductModel *productModel =[orderShopModel.productArray firstObject];
                
                _payRightNowManager.shopId = orderShopModel.shopId;
                _payRightNowManager.skuId = productModel.skuId;
                _payRightNowManager.goodsCount = productModel.count;
                _payRightNowManager.receiveId = addressModel.receivingId;
                
                [self showLoadingView];
                [_payRightNowManager loadData];
                
            } else {
                
                //购物车
                _shopCartSettleManager.receiveId = addressModel.receivingId;
                [self showLoadingView];
                [_shopCartSettleManager loadData];
                
            }
            
        };
        [self.navigationController pushViewController:myDeliveryAddressVC animated:YES];
        
        
    } else {
        
        WJOrderShopModel *orderShopModel = self.orderConfirmModel.shopArray[indexPath.section - 1];

        if (indexPath.row == orderShopModel.productArray.count + 1) {
            
            if ([self.orderConfirmModel.couponAmount floatValue] > 0) {
                
                //优惠券
                WJMyCouponViewController *myCouponVC = [[WJMyCouponViewController alloc] init];
                //            myCouponVC.showSelectedStatus = YES;
                //                myCouponVC.showSelectedStatus = NO;
                myCouponVC.fromVC = fromOrderConfirmController;
                
                myCouponVC.selectCouponBlock = ^(WJCouponModel *couponModel){
                    
                    WJOrderConfirmCell *customCell = (WJOrderConfirmCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                    
                    customCell.contentL.text = [NSString stringWithFormat:@"%@元优惠券",couponModel.amount];
                    self.orderConfirmModel.couponAmount =  couponModel.amount;
                    self.orderConfirmModel.couponId = couponModel.couponId;
                    [self refreshBottomView];
                };
                [self.navigationController pushViewController:myCouponVC animated:YES];
            }
        }
        
    }
    
    
//    else {
//
//        WJOrderShopModel *orderShopModel = self.orderConfirmModel.shopArray[indexPath.section - 1];
//        if (indexPath.row >= orderShopModel.productArray.count) {
//            
//            if (indexPath.row == orderShopModel.productArray.count) {
//                
//                //发票
//                WJInvoiceViewController *invoiceVC = [[WJInvoiceViewController alloc] init];
//                [self.navigationController pushViewController:invoiceVC animated:YES];
//            }
//        }
//    }

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
-(void)submitButtonAction
{
    [MobClick event:@"dd_tijiao"];
    
    if (self.orderConfirmModel.receiverName.length == 0 || self.orderConfirmModel.phoneNumber.length == 0 || self.orderConfirmModel.address.length == 0) {
        
        [[TKAlertCenter defaultCenter]  postAlertWithMessage:@"收货信息不全"];
        
    } else {
        
        if (self.orderConfirmFromController == FromPayRightNow) {
            
            //立即购买
            self.submitOrderManager.submitType = @"2";
            self.submitOrderManager.receiveId = self.orderConfirmModel.receivingId;
            self.submitOrderManager.couponId = self.orderConfirmModel.couponId;
            self.submitOrderManager.totalAmount = [NSString stringWithFormat:@"%f",totalOrderAmount];

            self.submitOrderManager.shopId = self.payRightNowManager.shopId;
            self.submitOrderManager.skuId = self.payRightNowManager.skuId;
            self.submitOrderManager.goodsCount = self.payRightNowManager.goodsCount;
            
        } else {
            
            //购物车
            self.submitOrderManager.submitType = @"1";
            self.submitOrderManager.couponId = self.orderConfirmModel.couponId;
            self.submitOrderManager.receiveId = self.orderConfirmModel.receivingId;
            self.submitOrderManager.totalAmount = [NSString stringWithFormat:@"%f",totalOrderAmount];

            self.submitOrderManager.cartIdListString = self.cardIdString;

        }
        [self showLoadingView];
        [self.submitOrderManager loadData];
    }
}

-(void)refreshBottomView
{
    totalOrderAmount = 0;
    CGFloat totalCoupon = 0;
    CGFloat   totalDeliverFee = 0;
    
    for (WJOrderShopModel *orderShopModel in self.orderConfirmModel.shopArray) {
        
        totalDeliverFee += [orderShopModel.deliverFee floatValue];
        totalCoupon += [orderShopModel.couponAmount floatValue];
        
        for (WJProductModel *productModel in orderShopModel.productArray) {
            totalOrderAmount += [productModel.salePrice floatValue] * productModel.count;
            
        }
    }
    
    totalOrderAmount += totalDeliverFee;

    if (self.orderConfirmFromController == FromPayRightNow) {
        
        //立即购买
        totalOrderAmount -= [self.orderConfirmModel.couponAmount floatValue];
//        couponL.text = [NSString stringWithFormat:@"(优惠券抵扣%.2f元)",[self.orderConfirmModel.couponAmount floatValue]];

        
    } else {
        //购物车
        totalOrderAmount -= totalCoupon;
//        couponL.text = [NSString stringWithFormat:@"(优惠券抵扣%.2f元)",totalCoupon];

    }

    totalAmountL.text = [NSString stringWithFormat:@"合计: ¥%.2f",totalOrderAmount];
}

#pragma mark - 属性方法
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarAndStatBarHeight - ALD(49)) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorColor = WJColorSeparatorLine;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(NSArray *)listArray
{
//    return @[
//             @{@"name":@"发票信息",@"text":@"明细(电子)-个人"},
//             @{@"name":@"配送方式",@"text":@"快递免邮"},
//             @{@"name":@"优惠券",@"text":@"10元优惠券"}
//             ];
    
    return @[
             @{@"name":@"配送费",@"text":@"免邮"},
             @{@"name":@"优惠券",@"text":@"暂无"}
             ];
}

-(APIShopCartSettleManager *)shopCartSettleManager
{
    if (_shopCartSettleManager == nil) {
        _shopCartSettleManager = [[APIShopCartSettleManager alloc] init];
        _shopCartSettleManager.delegate = self;
    }
    
    _shopCartSettleManager.userId = USER_ID;
    _shopCartSettleManager.cartIdListString = self.cardIdString;
    return _shopCartSettleManager;
}

-(APIPayRightNowManager *)payRightNowManager
{
    if (_payRightNowManager == nil) {
        _payRightNowManager = [[APIPayRightNowManager alloc] init];
        _payRightNowManager.delegate = self;
    }
    _payRightNowManager.userId = USER_ID;
    return _payRightNowManager;
}


-(APISubmitOrderManager *)submitOrderManager
{
    if (_submitOrderManager == nil) {
        _submitOrderManager = [[APISubmitOrderManager alloc] init];
        _submitOrderManager.delegate = self;
    }
    _submitOrderManager.userId = USER_ID;
    return _submitOrderManager;
}



@end
