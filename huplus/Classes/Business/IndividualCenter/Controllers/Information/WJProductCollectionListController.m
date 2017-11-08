//
//  WJProductCollectionListController.m
//  HuPlus
//
//  Created by reborn on 17/3/24.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJProductCollectionListController.h"
#import "WJRefreshCollectionView.h"
#import "APIMyCollectionManager.h"
#import "APIDeleteCollectionManager.h"
#import "WJMyCollectionModel.h"
#import "WJHomeGoodsModel.h"
#import "WJSystemAlertView.h"
#import "WJEmptyView.h"
#import "WJHomeRecommendCollectionViewCell.h"

#define kDefaultCellIdentifier              @"kDefaultCellIdentifier"
#define kCollectionCellIdentifier           @"kCollectionCellIdentifier"

@interface WJProductCollectionListController ()<UICollectionViewDelegate,UICollectionViewDataSource,WJSystemAlertViewDelegate,APIManagerCallBackDelegate>
{
    NSInteger deleteIndex;
    BOOL      isShowDelete;
    BOOL      isHeaderRefresh;
    BOOL      isFooterRefresh;
    
    UIView         *noDataView;
    
    NSInteger      totalCount;
}
@property(nonatomic, strong)APIMyCollectionManager      *myCollectionManager;
@property(nonatomic, strong)APIDeleteCollectionManager  *deleteCollectionManager;
@property(nonatomic, strong)NSMutableArray              *listArray;
@property(nonatomic, strong)WJMyCollectionModel         *myCollectionModel;
@property(nonatomic, strong)WJHomeGoodsModel            *deleteModel;
@end

@implementation WJProductCollectionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isHiddenTabBar = YES;
    isShowDelete = NO;
    [self.view addSubview:self.collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStatus:) name:@"refreshDeleteStatus" object:nil];


    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WJEmptyView *emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(86), kScreenWidth, ALD(140))];
    emptyView.tipLabel.text = @"您还没有收藏的商品";
    emptyView.imageView.image = [UIImage imageNamed:@"collection_nodata_image"];
    [noDataView addSubview:emptyView];
    noDataView.hidden = YES;
    [self.view addSubview:noDataView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RequestData
- (void)requestData{
    
    self.myCollectionManager.currentPage = 1;
    [self.myCollectionManager loadData];
}

- (void)reloadMoreData{
    
    [self.myCollectionManager loadData];
}

-(void)refreshStatus:(NSNotification *)note
{
    isShowDelete =  [note.userInfo objectForKey:@"isShowDelete"];
    
    [self.collectionView reloadData];
}

#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshCollectionView *)collectionView
{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.myCollectionManager.shouldCleanData = YES;
        if (self.listArray.count > 0) {
            [self.listArray removeAllObjects];
        }
        [self requestData];
    }
    
}

- (void)startFootRefreshToDo:(WJRefreshCollectionView *)collectionView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        self.myCollectionManager.shouldCleanData = NO;
        [self reloadMoreData];
    }
}

- (void)endGetData:(BOOL)needReloadData{
    
    if (isHeaderRefresh) {
        isHeaderRefresh = NO;
        [self.collectionView endHeadRefresh];
    }
    
    if (isFooterRefresh){
        isFooterRefresh = NO;
        [self.collectionView endFootFefresh];
    }
    
    if (needReloadData) {
        [self.collectionView reloadData];
    }
}

- (void)refreshFooterStatus:(BOOL)status{
    
    if (status) {
        [self.collectionView hiddenFooter];
    }else {
        [self.collectionView showFooter];
    }
    
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    if ([manager isKindOfClass:[APIMyCollectionManager class]]) {
        
        self.myCollectionModel = [[WJMyCollectionModel alloc] initWithDic:[manager fetchDataWithReformer:nil]];
        
        if (self.listArray.count == 0) {
            self.listArray = self.myCollectionModel.collectionListArray;
            
        } else {
            
            if (self.myCollectionManager.currentPage < self.myCollectionModel.totalCount) {
                [self.listArray addObjectsFromArray: self.myCollectionModel.collectionListArray];
            }
        }
        
        if (self.listArray.count != 0) {
            noDataView.hidden = YES;
        }else{
            noDataView.hidden = NO;
        }
        
        [self endGetData:YES];
        [self refreshFooterStatus:manager.hadGotAllData];
        
    } else if ([manager isKindOfClass:[APIDeleteCollectionManager class]]) {
        
        [self.listArray removeObjectAtIndex:deleteIndex];
        [self.collectionView reloadData];
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    if ([manager isKindOfClass:[APIMyCollectionManager class]]) {
        
        [self endGetData:NO];
        
        if (manager.errorType == APIManagerErrorTypeNoData) {
            self.listArray = nil;
            [self.collectionView reloadData];
        }
        
        if (self.listArray.count != 0) {
            noDataView.hidden = YES;
        }else{
            noDataView.hidden = NO;
        }
        
    }
}

#pragma mark - CollectionViewDelegate/CollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.listArray == nil || self.listArray.count == 0) {
        return 0;
    } else {
        return self.listArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WJHomeRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
    [cell configDataWithModel:self.listArray[indexPath.row] isShowDelete:isShowDelete];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth - ALD(10))/3, (kScreenWidth - ALD(10))/3 + ALD(75));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return ALD(5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isShowDelete) {
        WJSystemAlertView *alertView = [[WJSystemAlertView alloc] initWithTitle:@"提示" message:@"确定取消该收藏吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" textAlignment:NSTextAlignmentCenter];
        [alertView showIn];
        deleteIndex = indexPath.row;
    }
    
}

#pragma mark - WJSystemAlertViewDelegate
-(void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"取消");
        
    } else {
        NSLog(@"确定");
        self.deleteModel = self.listArray[deleteIndex];
        [self.deleteCollectionManager loadData];
        
    }
}


-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[WJRefreshCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = WJColorViewBg;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kDefaultCellIdentifier];
        
        [_collectionView registerClass:[WJHomeRecommendCollectionViewCell class] forCellWithReuseIdentifier:kCollectionCellIdentifier];
        
    }
    return _collectionView;
}

-(NSMutableArray *)listArray
{
    if (nil == _listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (APIMyCollectionManager *)myCollectionManager
{
    if (nil == _myCollectionManager) {
        _myCollectionManager = [[APIMyCollectionManager alloc] init];
        _myCollectionManager.delegate = self;
    }
    _myCollectionManager.userId = USER_ID;
    return _myCollectionManager;
}

-(APIDeleteCollectionManager *)deleteCollectionManager
{
    if (nil == _deleteCollectionManager) {
        _deleteCollectionManager = [[APIDeleteCollectionManager alloc] init];
        _deleteCollectionManager.delegate = self;
    }
    _deleteCollectionManager.userId = USER_ID;
    _deleteCollectionManager.productId = self.deleteModel.productId;
    return _deleteCollectionManager;
}



@end
