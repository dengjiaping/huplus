//
//  WJThirdShopListController.m
//  HuPlus
//
//  Created by reborn on 17/2/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJThirdShopListController.h"
#import "WJRefreshTableView.h"
#import "WJThirdShopListCell.h"
#import "WJThirdShopListModel.h"
#import "WJThirdShopViewController.h"
#import "APIThirdShopListManager.h"
#import "WJThirdShopModel.h"
#import "WJThirdShopListReformer.h"
#import "WJThirdShopDetailViewController.h"
#import "WJSystemAlertView.h"


#define kThirdShopCellIdentifier    @"kThirdShopCellIdentifier"

@interface WJThirdShopListController ()<UITableViewDelegate,UITableViewDataSource,APIManagerCallBackDelegate>
{
    BOOL      isHeaderRefresh;
    BOOL      isFooterRefresh;
    NSInteger totalPage;
}
@property(nonatomic,strong)WJRefreshTableView      *tableView;
@property(nonatomic,strong)NSMutableArray          *shopListArray;
@property(nonatomic,strong)APIThirdShopListManager *thirdShopListManager;
@property(nonatomic,strong)WJThirdShopModel        *thirdShopModel;
@end

@implementation WJThirdShopListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺";
    [self hiddenBackBarButtonItem];
    [self.view addSubview:self.tableView];
    
    [self showLoadingView];
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:kTabThirdShopRefresh object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)refreshList
{
    [self.tableView startHeadRefresh];
}

#pragma mark - RequestData
- (void)requestData{
    
    if (self.shopListArray.count > 0) {
        [self.shopListArray removeAllObjects];
    }
    self.thirdShopListManager.shouldCleanData = YES;
    self.thirdShopListManager.currentPage = 1;
    [self.thirdShopListManager loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        if (self.shopListArray.count > 0) {
            [self.shopListArray removeAllObjects];
        }
        self.thirdShopListManager.shouldCleanData = YES;
        [self requestData];
    }
    
}

- (void)startFootRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        self.thirdShopListManager.shouldCleanData = NO;
        [self.thirdShopListManager loadData];
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
    
    if (self.shopListArray.count > 0) {
        
    } else {
        
    }
    
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    self.thirdShopModel  = [manager fetchDataWithReformer:[[WJThirdShopListReformer alloc] init]];
    totalPage = self.thirdShopModel.totalPage;
    
    if (self.shopListArray.count == 0) {
        self.shopListArray = self.thirdShopModel.shopListArray;
        
    } else {
        
        if (self.thirdShopListManager.currentPage < totalPage) {
            
            [self.shopListArray addObjectsFromArray: self.thirdShopModel.shopListArray];
        }
    }
    
    [self endGetData:YES];
    [self refreshFooterStatus:manager.hadGotAllData];
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    if (manager.errorType == APIManagerErrorTypeNoData) {
        [self refreshFooterStatus:YES];
        
        if (isHeaderRefresh) {
            if (self.shopListArray.count > 0) {
                [self.shopListArray removeAllObjects];
                
            }
            [self endGetData:YES];
            return;
        }
        [self endGetData:NO];
        
    } else {
        
        [self refreshFooterStatus:self.thirdShopListManager.hadGotAllData];
        [self endGetData:NO];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.shopListArray.count == 0 || self.shopListArray == nil) {
        return 0;
    } else {
        return self.shopListArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(202);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJThirdShopListCell *cell = [tableView dequeueReusableCellWithIdentifier:kThirdShopCellIdentifier];
    if (!cell) {
        cell = [[WJThirdShopListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kThirdShopCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorViewBg2;
    }
    if (self.shopListArray.count > 0) {
        
        [cell configDataWithThirdShopListModel:self.shopListArray[indexPath.row]];
    }
    
    
    __weak typeof(self)  weakSelf = self;
    
    cell.skipStoreBlock = ^{
        
        __strong typeof(self) strongSelf = weakSelf;
        
        WJThirdShopDetailViewController *thirdShopVC = [[WJThirdShopDetailViewController alloc] init];
        thirdShopVC.shopId = [strongSelf.shopListArray[indexPath.row] shopId];
        [strongSelf.navigationController pushViewController:thirdShopVC animated:NO];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJThirdShopDetailViewController *thirdShopVC = [[WJThirdShopDetailViewController alloc] init];
    thirdShopVC.shopId = [self.shopListArray[indexPath.row] shopId];
    [self.navigationController pushViewController:thirdShopVC animated:NO];
}


#pragma mark - setter/getter
- (WJRefreshTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[WJRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg2;
    }
    return _tableView;
}

- (NSMutableArray *)shopListArray{
    if (!_shopListArray) {
        _shopListArray = [NSMutableArray array];
    }
    return _shopListArray;
}

-(APIThirdShopListManager *)thirdShopListManager
{
    if (_thirdShopListManager == nil) {
        _thirdShopListManager = [[APIThirdShopListManager alloc] init];
        _thirdShopListManager.delegate = self;
    }
    _thirdShopListManager.shouldParse = YES;
    return _thirdShopListManager;
}

@end
