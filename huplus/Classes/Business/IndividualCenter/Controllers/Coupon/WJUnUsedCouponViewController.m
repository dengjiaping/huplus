//
//  WJUnUsedCouponViewController.m
//  HuPlus
//
//  Created by reborn on 16/12/25.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJUnUsedCouponViewController.h"
#import "WJRefreshTableView.h"
#import "WJCouponCell.h"
#import "WJCouponModel.h"
#import "APIMyCouponManager.h"
#import "WJMyCouponReformer.h"
#import "WJCouponListModel.h"
#import "WJEmptyView.h"

#define kCouponTableViewCellIdentifier    @"kCouponTableViewCellIdentifier"
#define kCouponTabSegmentHeight           ALD(50)

@interface WJUnUsedCouponViewController ()<UITableViewDelegate,UITableViewDataSource,APIManagerCallBackDelegate>
{
    BOOL            isHeaderRefresh;
    BOOL            isFooterRefresh;
    NSInteger       totalPage;
    
    NSInteger       noUseCount;
    NSInteger       useCount;
    NSInteger       expiredCount;
    UIView          *noDataView;

}

@property(nonatomic,strong)APIMyCouponManager *myCouponManager;
@property(nonatomic,strong)NSMutableArray     *couponsListArray;
@property(nonatomic,strong)WJCouponListModel  *couponListModel;

@end

@implementation WJUnUsedCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenTabBar = YES;
    self.view.backgroundColor = WJColorViewBg;
    [self.view addSubview:self.tableView];
    
    [self requestData];
    
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WJEmptyView *emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(86), kScreenWidth, ALD(140))];
    emptyView.tipLabel.text = @"您还没有优惠券";
    emptyView.imageView.image = [UIImage imageNamed:@"coupon_nodata_image"];
    [noDataView addSubview:emptyView];
    
}

#pragma mark - Request

-(void)requestData
{
    if (self.couponsListArray.count > 0) {
        [self.couponsListArray removeAllObjects];
    }
    self.myCouponManager.shouldCleanData = YES;
    self.myCouponManager.currentPage = 1;
    [self.myCouponManager loadData];
    
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
        if (self.couponsListArray.count > 0) {
            [self.couponsListArray removeAllObjects];
        }
        self.myCouponManager.shouldCleanData = YES;
        [self requestData];
    }
    
}

- (void)startFootRefreshToDo:(UITableView *)tableView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        self.myCouponManager.shouldCleanData = NO;
        [self requestData];

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
    
    if (self.couponsListArray.count > 0) {
        self.tableView.tableFooterView = [UIView new];
        
    } else {
        self.tableView.tableFooterView = noDataView;
    }
    
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIMyCouponManager class]]) {
        
        self.couponListModel = [manager fetchDataWithReformer:[[WJMyCouponReformer alloc] init]];
        
        totalPage = self.couponListModel.totalCount;
        noUseCount = self.couponListModel.noUseCount;
        useCount = self.couponListModel.useCount;
        expiredCount = self.couponListModel.expiredCount;
        
        if (self.couponsListArray.count == 0) {
            self.couponsListArray = self.couponListModel.couponListArray;
            
        } else {
            
            if (self.myCouponManager.currentPage < totalPage) {
                
                [self.couponsListArray addObjectsFromArray:self.couponListModel.couponListArray];
            }
        }


        NSMutableDictionary *countDic = [NSMutableDictionary dictionary];
        [countDic setValue:NumberToString(noUseCount) forKey:@"noUseCount"];
        [countDic setValue:NumberToString(useCount) forKey:@"useCount"];
        [countDic setValue:NumberToString(expiredCount) forKey:@"expiredCount"];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSegmentCount"  object:nil userInfo:countDic];
        
        [self endGetData:YES];
        [self refreshFooterStatus:manager.hadGotAllData];
        
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIMyCouponManager class]]) {
        if (manager.errorType == APIManagerErrorTypeNoData) {
            [self refreshFooterStatus:YES];
            
            if (isHeaderRefresh) {
                if (self.couponsListArray.count > 0) {
                    [self.couponsListArray removeAllObjects];
                    
                }
                [self endGetData:YES];
                return;
            }
            [self endGetData:NO];
            
        }else{
            
            [self refreshFooterStatus:self.myCouponManager.hadGotAllData];
            [self endGetData:NO];
            
        }
        
    }
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.couponsListArray == nil || self.couponsListArray.count == 0) {
        return 0;
    } else {
        return self.couponsListArray.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(85);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(10);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:kCouponTableViewCellIdentifier];
    if (!cell) {
        cell = [[WJCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCouponTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorViewBg2;
    }

    [cell configDataWithCoupon:self.couponsListArray[indexPath.section]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (self.fromVC == fromOrderConfirmController) {
        
        id object = self.couponsListArray[indexPath.section];
        
        if ([object isKindOfClass:[WJCouponModel class]]) {
            
            WJCouponModel *tCouponModel = (WJCouponModel *)object;
            
            if (self.selectCouponBlock) {
                
                self.selectCouponBlock(tCouponModel);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    

}


#pragma mark - setter/getter

-(WJRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - kCouponTabSegmentHeight - kNavigationBarHeight) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (NSMutableArray *)couponsListArray{
    if (!_couponsListArray) {
        _couponsListArray = [NSMutableArray array];
    }
    return _couponsListArray;
}

-(APIMyCouponManager *)myCouponManager
{
    if (nil == _myCouponManager) {
        _myCouponManager = [[APIMyCouponManager alloc] init];
        _myCouponManager.delegate = self;
    }
    _myCouponManager.userId = USER_ID;
    _myCouponManager.couponCurrentStatus = CouponStatusNoUse;
    _myCouponManager.shouldParse = YES;

    return _myCouponManager;
}


@end
