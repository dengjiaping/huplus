//
//  WJFinishOrderController.m
//  HuPlus
//
//  Created by reborn on 16/12/21.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJFinishOrderController.h"
#import "WJRefreshTableView.h"
#import "WJOrderCell.h"
#import "WJOrderDetailController.h"
#import "WJProductModel.h"
#import "APIOrderListManager.h"
#import "WJOrderListModel.h"
#import "WJOrderListReformer.h"
#define kOrderTabSegmentHeight      ALD(50)
@interface WJFinishOrderController ()<UITableViewDelegate,UITableViewDataSource,APIManagerCallBackDelegate>
{
    BOOL      isHeaderRefresh;
    BOOL      isFooterRefresh;
}

@property(nonatomic,strong)APIOrderListManager *orderListManager;
@property(nonatomic,strong)NSMutableArray      *orderArray;
@property(nonatomic,strong)WJOrderListModel    *orderListModel;

@end

@implementation WJFinishOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已完成";
    self.isHiddenTabBar = YES;

    //取消订单 刷新
    [kDefaultCenter addObserver:self selector:@selector(reloadOrder) name:kDeleteOrderSuccess object:nil];
    [self.view addSubview:self.tableView];
}

-(void)reloadOrder
{
    [self requestData];
}

#pragma mark - Request

- (void)requestData{
    
    if (self.orderArray.count > 0) {
        [self.orderArray removeAllObjects];
    }
    self.orderListManager.shouldCleanData = YES;
    self.orderListManager.currentPage = 1;
    [self.orderListManager loadData];
}

#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.orderListManager.shouldCleanData = YES;
        [self requestData];
    }
    
}

- (void)startFootRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        self.orderListManager.shouldCleanData = NO;
        [self.orderListManager loadData];
    }
}

- (void)endGetData:(BOOL)needReloadData{
    
    if (isHeaderRefresh) {
        isHeaderRefresh = NO;
        [self.tableView endHeadRefresh];
    }
    
    if (isFooterRefresh){
        isFooterRefresh = NO;
        [self.tableView endFootFefresh];
    }
    
    if (needReloadData) {
        [self.tableView reloadData];
    }
}

- (void)refreshFooterStatus:(BOOL)status{
    
    if (status) {
        [self.tableView hiddenFooter];
    } else {
        [self.tableView showFooter];
    }
    
    if (self.orderArray.count > 0) {
        
    } else {
        
    }
    
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIOrderListManager class]]) {
        self.orderListModel = [manager fetchDataWithReformer:[[WJOrderListReformer alloc] init]];
        
        if (self.orderArray.count == 0) {
            
            self.orderArray =  self.orderListModel.orderList;
            
        } else {
            
            if (self.orderListManager.currentPage < self.orderListModel.totalPage) {
                
                [self.orderArray addObjectsFromArray: self.orderListModel.orderList];
            }
        }
        
        [self endGetData:YES];
        [self refreshFooterStatus:manager.hadGotAllData];
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIOrderListManager class]]) {
        
        if (manager.errorType == APIManagerErrorTypeNoData) {
            [self refreshFooterStatus:YES];
            
            if (isHeaderRefresh) {
                if (self.orderArray.count > 0) {
                    [self.orderArray removeAllObjects];
                    
                }
                [self endGetData:YES];
                return;
            }
            [self endGetData:NO];
            
        } else {
            
            [self refreshFooterStatus:self.orderListManager.hadGotAllData];
            [self endGetData:NO];
            
        }
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.orderArray == nil || self.orderArray.count == 0) {
        return 0;
    } else {
        return self.orderArray.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(220);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0;
    } else {
        return ALD(10);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *orderCellIdentifier = @"orderCellIdentifier";

    WJOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier];
    if (!cell) {
        cell = [[WJOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorWhite;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
    }

    __weak typeof(self) weakSelf = self;
    cell.checkMoreBlock = ^ {
        
        __strong typeof(self) strongSelf = weakSelf;
        //查看更多
        [strongSelf.delegate performSelector:@selector(CheckMoreWithOrder:) withObject:self.orderArray[indexPath.section]];
    };
    if (self.orderArray.count > 0) {
        
        [cell configDataWithOrder:self.orderArray[indexPath.section]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJOrderDetailController *orderDetailVC = [[WJOrderDetailController alloc] init];
    
    WJOrderModel *orderModel = self.orderArray[indexPath.section];
    orderDetailVC.orderId = orderModel.orderNo;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark - setter/getter
-(WJRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight  - kOrderTabSegmentHeight - kNavigationBarHeight) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (NSMutableArray *)orderArray{
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}

-(APIOrderListManager *)orderListManager
{
    if (_orderListManager == nil) {
        _orderListManager = [[APIOrderListManager alloc] init];
        _orderListManager.delegate = self;
    }
    _orderListManager.userId = USER_ID;
    _orderListManager.orderStatus = OrderStatusSuccess;
    return _orderListManager;
}
@end
