//
//  WJIndividualRefundViewController.m
//  HuPlus
//
//  Created by reborn on 17/1/5.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJIndividualRefundViewController.h"
#import "WJRefundCell.h"
#import "WJEmptyView.h"
#import "APIRefundListManager.h"
#import "WJOrderListModel.h"
#import "WJOrderListReformer.h"
#import "WJRefundProgressViewController.h"
#import "AppDelegate.h"

@interface WJIndividualRefundViewController ()<UITableViewDelegate,UITableViewDataSource,APIManagerCallBackDelegate>
{
    BOOL      isHeaderRefresh;
    BOOL      isFooterRefresh;
    UIView    *noDataView;
}

@property(nonatomic,strong)APIRefundListManager *refundListManager;
@property(nonatomic,strong)WJOrderListModel     *orderListModel;
@property(nonatomic, strong)NSMutableArray       *listArray;


@end

@implementation WJIndividualRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"退款/售后";
    self.isHiddenTabBar = YES;
    
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WJEmptyView *emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(86), kScreenWidth, ALD(140))];
    emptyView.tipLabel.text = @"您还没有相关的内容";
    emptyView.imageView.image = [UIImage imageNamed:@"refund_nodata_image"];
    [noDataView addSubview:emptyView];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView startHeadRefresh];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

- (void)requestData{
    
    if (self.listArray.count > 0) {
        [self.listArray removeAllObjects];
    }
    self.refundListManager.shouldCleanData = YES;
    self.refundListManager.currentPage = 1;
    [self showLoadingView];
    [self.refundListManager loadData];
}

#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        if (self.listArray.count > 0) {
            [self.listArray removeAllObjects];
        }
        self.refundListManager.shouldCleanData = YES;
        [self requestData];
    }
    
}

- (void)startFootRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        self.refundListManager.shouldCleanData = NO;
        [self.refundListManager loadData];
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
    
    if (self.listArray.count > 0) {
        self.tableView.tableFooterView = [UIView new];
        
    } else {
        
        self.tableView.tableFooterView = noDataView;
    }
    
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIRefundListManager class]]) {
        
        self.orderListModel = [manager fetchDataWithReformer:[[WJOrderListReformer alloc] init]];
        
        if (self.listArray.count == 0) {
            
            self.listArray =  self.orderListModel.orderList;
            
        } else {
            
            if (self.refundListManager.currentPage < self.orderListModel.totalPage) {
                
                [self.listArray addObjectsFromArray: self.orderListModel.orderList];
            }
        }
        
        [self endGetData:YES];
        [self refreshFooterStatus:manager.hadGotAllData];
        
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    if ([manager isKindOfClass:[APIRefundListManager class]]) {
        
        if (manager.errorType == APIManagerErrorTypeNoData) {
            [self refreshFooterStatus:YES];
            
            if (isHeaderRefresh) {
                if (self.listArray.count > 0) {
                    [self.listArray removeAllObjects];
                    
                }
                [self endGetData:YES];
                return;
            }
            [self endGetData:NO];
            
        } else {
            
            [self refreshFooterStatus:self.refundListManager.hadGotAllData];
            [self endGetData:NO];
            
        }
        
    }
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
    
    WJRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WJRefundCell"];
    if (!cell) {
        cell = [[WJRefundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJRefundCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorWhite;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
    }
    
    __weak typeof(self) weakSelf = self;
    cell.checkProgress = ^{
        
        __strong typeof(self) strongSelf = weakSelf;
        //进度查询
        [strongSelf checkDeliverAddressWithOrder:self.listArray[indexPath.section]];
    };
    
    [cell configDataWithOrder:self.listArray[indexPath.section]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)checkDeliverAddressWithOrder:(WJOrderModel *)model
{
    WJRefundProgressViewController *refundProgressVC = [[WJRefundProgressViewController alloc] init];
    refundProgressVC.orderModel = model;
    [self.navigationController pushViewController:refundProgressVC animated:YES];

}

- (void)backBarButton:(UIButton *)btn{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.tabBarController.selectedIndex != 4) {
        
        [appDelegate.tabBarController changeTabIndex:4];
    }
}

#pragma mark - setter/getter

-(WJRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

-(APIRefundListManager *)refundListManager
{
    if (_refundListManager == nil) {
        _refundListManager = [[APIRefundListManager alloc] init];
        _refundListManager.delegate = self;
    }
    _refundListManager.userId = USER_ID;

    return _refundListManager;
}


@end
