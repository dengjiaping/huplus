//
//  WJAfterSalesApplicationController.m
//  HuPlus
//
//  Created by reborn on 16/12/29.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJAfterSalesApplicationController.h"
#import "WJAfterSalesCell.h"
#import "WJAfterSalesDetailController.h"
#import "WJProductDetailController.h"
@interface WJAfterSalesApplicationController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)NSMutableArray   *listArray;

@end

@implementation WJAfterSalesApplicationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"售后申请";
    // Do any additional setup after loading the view.
    self.isHiddenTabBar = YES;

    WJOrderStoreModel *orderStore = [self.detailOrder.orderStoreListArray firstObject];
    self.listArray = orderStore.productList;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    if (self.listArray == nil || self.listArray.count == 0) {
        return 0;
    } else {
        return self.listArray.count;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(150);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return ALD(44);
    } else {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = WJColorWhite;
    
    UILabel *orderNoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, ALD(250), ALD(44))];
    orderNoL.textColor = WJColorDarkGray;
    orderNoL.font = WJFont12;
    orderNoL.text = [NSString stringWithFormat:@"订单编号：%@",self.detailOrder.orderNo];
    orderNoL.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:orderNoL];

    
    UILabel *statusL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(10) - ALD(100), 0, ALD(100), ALD(44))];
    statusL.textColor = WJColorDarkGray;
    statusL.font = WJFont12;
    statusL.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:statusL];
    
    switch (self.detailOrder.orderStatus) {
        case OrderStatusSuccess:
        {
            statusL.text = @"完成";
        }
            break;
            
        case OrderStatusUnfinished:
        {
            statusL.text = @"待支付";

        }
            break;
            
        case OrderStatusWaitReceive:
        {
            statusL.text = @"卖家已发货";

        }
            break;
            
        case OrderStatusWaitDeliver:
        {
            statusL.text = @"待发货";

        }
            break;
            
        case OrderStatusClose:
        {
            statusL.text = @"已关闭";
        }
            break;
            
        default:
            break;
    }

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *afterSalesCellIdentifier = @"afterSalesCellIdentifier";
    
    WJAfterSalesCell *cell = [tableView dequeueReusableCellWithIdentifier:afterSalesCellIdentifier];
    if (!cell) {
        cell = [[WJAfterSalesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:afterSalesCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorWhite;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
    }
    
    __weak typeof(self) weakSelf = self;
    cell.afterSaleApplyBlock = ^{
        
        __strong typeof(self) strongSelf = weakSelf;
        //申请售后
        [strongSelf afterSaleApplyWithModel:self.listArray[indexPath.section] OrderId:self.detailOrder.orderNo];
        
    };
    
    [cell configDataWithModel:self.listArray[indexPath.section] isDetail:NO];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJProductDetailController * productDetailVC = [[WJProductDetailController alloc]init];
    productDetailVC.productId = [self.listArray[indexPath.section] productId];
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

#pragma mark - Action
-(void)afterSaleApplyWithModel:(WJProductModel *)model OrderId:(NSString *)orderId
{
    WJAfterSalesDetailController *afterSalesDetailVC = [[WJAfterSalesDetailController alloc] init];
    afterSalesDetailVC.productModel = model;
    afterSalesDetailVC.orderId = orderId;
    [self.navigationController pushViewController:afterSalesDetailVC animated:YES whetherJump:YES];
}

#pragma mark - setter/getter
-(WJRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64  - kNavigationBarHeight) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
    }
    return _tableView;
}

- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}


@end
