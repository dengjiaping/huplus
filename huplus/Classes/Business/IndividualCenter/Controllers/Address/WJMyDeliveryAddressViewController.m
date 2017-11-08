//
//  WJMyDeliveryAddressViewController.m
//  HuPlus
//
//  Created by reborn on 16/12/27.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJMyDeliveryAddressViewController.h"
#import "WJRefreshTableView.h"
#import "WJMyDeliveryAddressCell.h"
#import "WJDeliveryAddressModel.h"
#import "WJEditAddressViewController.h"
#import "APIMyDeliveryAddressManager.h"
#import "WJMyDeliveryAddressReformer.h"
#import "WJDeliveryAddressListModel.h"
#import "APIAddDeliveryAddressManager.h"
#import "APIDeleteDeliveryAddressManager.h"
#import "WJEmptyView.h"

#define kAddressCellIdentifier   @"kAddressCellIdentifier"
@interface WJMyDeliveryAddressViewController ()<UITableViewDelegate,UITableViewDataSource,APIManagerCallBackDelegate>
{
    BOOL      isHeaderRefresh;
    BOOL      isFooterRefresh;
    UIView    *noDataView;

}

@property(nonatomic,strong)WJRefreshTableView              *tableView;
@property(nonatomic,strong)APIMyDeliveryAddressManager     *myDeliveryAddressManager;
@property(nonatomic,strong)APIAddDeliveryAddressManager    *setDefaultAddressManager;      //设置默认
@property(nonatomic,strong)APIDeleteDeliveryAddressManager *deleteAddressManager;
@property(nonatomic,strong)NSMutableArray                  *listArray;

@property(nonatomic,strong)WJDeliveryAddressListModel      *addressListModel;
@property(nonatomic,strong)WJDeliveryAddressModel          *setDefaultModel;
@property(nonatomic,strong)WJDeliveryAddressModel          *deleteModel;

@end

@implementation WJMyDeliveryAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收货地址";
    self.isHiddenTabBar = YES;
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestLoad) name:@"refreshMyDeliveryAddress" object:nil];
    
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WJEmptyView *emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(86), kScreenWidth, ALD(140))];
    emptyView.tipLabel.text = @"请添加收货地址";
    emptyView.imageView.image = [UIImage imageNamed:@"address_nodata_image"];
    [noDataView addSubview:emptyView];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showLoadingView];
    [self requestLoad];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initBottomView
{
    UIButton *addAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddressButton.frame = CGRectMake(0, kScreenHeight - kNavBarAndStatBarHeight - ALD((44)), kScreenWidth, ALD(44));
    [addAddressButton setTitle:@"添加新地址" forState:UIControlStateNormal];
    [addAddressButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    addAddressButton.titleLabel.font = WJFont16;
    addAddressButton.backgroundColor = WJColorMainRed;
    [addAddressButton addTarget:self action:@selector(addAddressButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addAddressButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - refresh

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


- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        if (self.listArray.count > 0) {
            [self.listArray removeAllObjects];
        }
        self.myDeliveryAddressManager.shouldCleanData = YES;
        [self.myDeliveryAddressManager loadData];
    }
}


- (void)startFootRefreshToDo:(UITableView *)tableView{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        self.myDeliveryAddressManager.shouldCleanData = NO;
        [self.myDeliveryAddressManager loadData];
        
    }
}


#pragma mark - Request

- (void)requestLoad
{
    if (self.listArray.count > 0) {
        [self.listArray removeAllObjects];
    }
    self.myDeliveryAddressManager.shouldCleanData = YES;
    self.myDeliveryAddressManager.currentPage = 1;
    [self.myDeliveryAddressManager loadData];
}


- (void)deleteAddressRequest
{
    [self.deleteAddressManager loadData];
}

- (void)setDefaultAddressRequest
{
    [self.setDefaultAddressManager loadData];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    if ([manager isKindOfClass:[APIMyDeliveryAddressManager class]]) {
        
        self.addressListModel= [manager fetchDataWithReformer:[[WJMyDeliveryAddressReformer alloc] init]];
        
        if (self.listArray.count == 0) {
            self.listArray = self.addressListModel.addresslistArray;
            
        } else {
            
            if (self.myDeliveryAddressManager.currentPage < self.addressListModel.totalPage) {
                
                [self.listArray addObjectsFromArray:self.addressListModel.addresslistArray];
            }
        }
        [self initBottomView];

        [self endGetData:YES];
        [self refreshFooterStatus:manager.hadGotAllData];
        
    } else if ([manager isKindOfClass:[APIAddDeliveryAddressManager class]]) {
        
        for (WJDeliveryAddressModel *addressModel in self.listArray) {
            
            addressModel.isDefaultAddress = NO;
            
            if (addressModel == self.setDefaultModel) {
                addressModel.isDefaultAddress = YES;
                
            } else {
                addressModel.isDefaultAddress = NO;
            }
        }
        
        [self.tableView reloadData];
        
        if (self.fromVC == fromOrderConfirmVC) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyDeliveryAddress" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } else {
        
        [self.tableView startHeadRefresh];
        
        if (self.fromVC == fromOrderConfirmVC) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyDeliveryAddress" object:nil];
        }
        
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{

    if ([manager isKindOfClass:[APIMyDeliveryAddressManager class]]) {
        
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
            
            [self refreshFooterStatus:self.myDeliveryAddressManager.hadGotAllData];
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
    return ALD(110);
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
        
    WJMyDeliveryAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressCellIdentifier];
    if (!cell) {
        cell = [[WJMyDeliveryAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAddressCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorWhite;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
    }
    
    if (self.listArray.count > 0) {
        
        [cell configAddressdDataWithModel:self.listArray[indexPath.section]];
    }

    __weak typeof(self) weakSelf = self;
    
    cell.settingDefaultAddressBlock = ^{
        
        __strong typeof(self) strongSelf = weakSelf;
        
        WJDeliveryAddressModel *curModel = strongSelf.listArray[indexPath.section];
        
        strongSelf.setDefaultModel = curModel;

        [strongSelf setDefaultAddressRequest];
        
    };
    
    cell.editAddressBlock = ^{
        
        __strong typeof(self) strongSelf = weakSelf;

        WJDeliveryAddressModel *editModel = self.listArray[indexPath.section];

        WJEditAddressViewController *editAddressVC = [[WJEditAddressViewController alloc] init];
        editAddressVC.addressViewType = AddressViewTypeEdit;
        editAddressVC.deliveryAddressModel = editModel;
        [strongSelf.navigationController pushViewController:editAddressVC animated:YES];
        
    };
    
    cell.deleteAddressBlock = ^{
        
        __strong typeof(self) strongSelf = weakSelf;

        WJDeliveryAddressModel *deliveryAddressModel = self.listArray[indexPath.section];
        strongSelf.deleteModel = deliveryAddressModel;
        
        [strongSelf deleteAddressRequest];

    };
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.fromVC == fromOrderConfirmVC) {
        
        WJDeliveryAddressModel *deliveryAddressModel = self.listArray[indexPath.section];
        if (self.selectAddressBlock) {
            
            self.selectAddressBlock(deliveryAddressModel);
        }
        [self.navigationController popViewControllerAnimated:YES];

    }
}

#pragma mark - Action
-(void)addAddressButton
{
    WJEditAddressViewController *editAddressVC = [[WJEditAddressViewController alloc] init];
    editAddressVC.addressViewType = AddressViewTypeNew;
    [self.navigationController pushViewController:editAddressVC animated:YES];
}

#pragma mark - setter/getter

-(WJRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - ALD(64)) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

-(APIMyDeliveryAddressManager *)myDeliveryAddressManager
{
    if (_myDeliveryAddressManager == nil) {
        _myDeliveryAddressManager = [[APIMyDeliveryAddressManager alloc] init];
        _myDeliveryAddressManager.delegate = self;
    }
    _myDeliveryAddressManager.userId = USER_ID;
    return _myDeliveryAddressManager;
}

-(APIAddDeliveryAddressManager *)setDefaultAddressManager
{
    if (_setDefaultAddressManager == nil) {
        _setDefaultAddressManager = [[APIAddDeliveryAddressManager alloc] init];
        _setDefaultAddressManager.delegate = self;
    }
    
    _setDefaultAddressManager.userId = USER_ID;
    _setDefaultAddressManager.receiveId = self.setDefaultModel.receivingId;
    _setDefaultAddressManager.receiveName = self.setDefaultModel.name;
    _setDefaultAddressManager.phone = self.setDefaultModel.phone;
    _setDefaultAddressManager.provinceId = self.setDefaultModel.provinceId;
    _setDefaultAddressManager.cityId = self.setDefaultModel.cityId;
    _setDefaultAddressManager.districtId = self.setDefaultModel.districtId;
    _setDefaultAddressManager.detailAddress = self.setDefaultModel.detailAddress;
    _setDefaultAddressManager.isDefault = 1;
    _setDefaultAddressManager.operationType = 2;

    return _setDefaultAddressManager;
}

-(APIDeleteDeliveryAddressManager *)deleteAddressManager
{
    if (_deleteAddressManager == nil) {
        _deleteAddressManager = [[APIDeleteDeliveryAddressManager alloc] init];
        _deleteAddressManager.delegate = self;
    }
    _deleteAddressManager.userId = USER_ID;
    _deleteAddressManager.receiveId = self.deleteModel.receivingId;
    return _deleteAddressManager;
}
@end
