//
//  WJLogisticsViewController.m
//  HuPlus
//
//  Created by reborn on 17/2/25.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJLogisticsViewController.h"
#import "WJSystemNewsModel.h"
#import "WJLogisticsNoticeCell.h"
#import "WJLogisticsDetailViewController.h"
#import "APIMessageListManager.h"
#import "WJMessageListReformer.h"
#import "WJMessageListModel.h"
@interface WJLogisticsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL      isHeaderRefresh;
    BOOL      isFooterRefresh;
}
@property (nonatomic, strong)APIMessageListManager  *messageListManager;
@property (nonatomic, strong)WJMessageListModel     *messageListModel;
@property (nonatomic, strong)WJRefreshTableView     *tableView;
@property (nonatomic, strong)NSMutableArray         *listArray;


@end

@implementation WJLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流通知";
    self.isHiddenTabBar = YES;
    
    [self.view addSubview:self.tableView];

    [self showLoadingView];
    [self requestData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
-(void)requestData
{
    self.messageListManager.shouldCleanData = YES;
    self.messageListManager.currentPage = 1;
    [self.messageListManager loadData];
}

#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.messageListManager.shouldCleanData = YES;
        if (self.listArray.count > 0) {
            [self.listArray removeAllObjects];
            
        }
        [self.messageListManager loadData];
    }
    
}

- (void)startFootRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        self.messageListManager.shouldCleanData = NO;
        [self.messageListManager loadData];

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
        
    } else {
        
    }
    
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    if ([manager isKindOfClass:[APIMessageListManager class]]) {
        
        self.messageListModel = [manager fetchDataWithReformer:[[WJMessageListReformer alloc] init]];
        
        if (self.listArray.count == 0) {
            self.listArray = self.messageListModel.messageListArray;
            
        } else {
            
            if (self.messageListManager.currentPage <self.messageListModel.totalPage) {
                
                [self.listArray addObjectsFromArray:self.messageListModel.messageListArray];
            }
        }
                
        [self endGetData:YES];
        [self refreshFooterStatus:manager.hadGotAllData];
        
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];

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
        
        [self refreshFooterStatus:self.messageListManager.hadGotAllData];
        [self endGetData:NO];
    }
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.listArray == nil || self.listArray.count == 0) {
        return 0;
    } else {
        return self.listArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(160);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJLogisticsNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogisticsNoticeCellIdentifier"];
    if (nil == cell) {
        cell = [[WJLogisticsNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LogisticsNoticeCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell configData:self.listArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJLogisticsDetailViewController *logisticsDetailVC = [[WJLogisticsDetailViewController alloc] init];
    logisticsDetailVC.orderId = [self.listArray[indexPath.row] orderNo];
    [self.navigationController pushViewController:logisticsDetailVC animated:YES];
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight)
                                                         style:UITableViewStylePlain
                                                    refreshNow:NO
                                               refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = WJColorViewBg2;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

-(NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}


-(APIMessageListManager *)messageListManager
{
    if (_messageListManager == nil) {
        _messageListManager = [[APIMessageListManager alloc] init];
        _messageListManager.delegate = self;
    }
    _messageListManager.userId = USER_ID;
    _messageListManager.messageType = @"2";
    return _messageListManager;
}
@end
