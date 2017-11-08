//
//  WJBrandViewController.m
//  HuPlus
//
//  Created by reborn on 17/1/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJBrandViewController.h"
#import "WJBrandCollectionViewCell.h"
#import "WJBrandModel.h"
#import "WJBrandDetailController.h"
#import "APIBrandListManager.h"
#import "WJBrandViewReformer.h"
#import "WJRefreshCollectionView.h"
#define kBrandCollectionViewCellIdentifier   @"kBrandCollectionViewCellIdentifier"

@interface WJBrandViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,APIManagerCallBackDelegate>
{
    BOOL      isHeaderRefresh;
    BOOL      isFooterRefresh;
}
@property(nonatomic, strong)APIBrandListManager      *brandListManager;
@property(nonatomic, strong)WJRefreshCollectionView  *collectionView;
@property(nonatomic, strong)NSMutableArray           *dataArray;
@property(nonatomic, assign)NSInteger                totalPage;


@end

@implementation WJBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌";
    self.isHiddenTabBar = YES;

    [self.view addSubview:self.collectionView];
    
    [self showLoadingView];
    [self requestData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - RequestData
- (void)requestData{
    
    self.brandListManager.shouldCleanData = YES;
    self.brandListManager.currentPage = 1;
    [self.brandListManager loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WJRefreshCollectionView Delegate

- (void)startHeadRefreshToDo:(WJRefreshCollectionView *)collectionView
{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.brandListManager.shouldCleanData = YES;
        
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
            
        }
        [self requestData];
    }
    
}

- (void)startFootRefreshToDo:(WJRefreshCollectionView *)collectionView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        self.brandListManager.shouldCleanData = NO;
        [self.brandListManager loadData];
        
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
        
    } else {
        
        [self.collectionView showFooter];
    }
    
    if (self.dataArray.count > 0) {
        
    } else {
        
    }
    
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    NSDictionary *dataDic = [manager fetchDataWithReformer:[[WJBrandViewReformer alloc]init]];
    self.totalPage = [dataDic[@"total_page"] integerValue];
    
    if (self.dataArray.count == 0) {
        self.dataArray = dataDic[@"brand_list"];
        
    } else {
        
        if (self.brandListManager.currentPage < self.totalPage) {
            
            [self.dataArray addObjectsFromArray:dataDic[@"brand_list"]];
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
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
                
            }
            [self endGetData:YES];
            return;
        }
        [self endGetData:NO];
        
    } else {
        
        [self refreshFooterStatus:self.brandListManager.hadGotAllData];
        [self endGetData:NO];
    }
}


#pragma mark - CollectionViewDelegate/CollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataArray == nil || self.dataArray.count == 0) {
        
        return 0;
    } else {
        
        return self.dataArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WJBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrandCollectionViewCellIdentifier forIndexPath:indexPath];
    
    [cell configDataWithBrandModel:self.dataArray[indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth/3,kScreenWidth/3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WJBrandDetailController *brandDetailVC = [[WJBrandDetailController alloc] init];
    WJBrandModel *brandModel = self.dataArray[indexPath.row];
    brandDetailVC.brandId = brandModel.brandID;
    [self.navigationController pushViewController:brandDetailVC animated:YES];
}


#pragma mark - setter属性
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[WJRefreshCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,  kScreenHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = WJColorWhite;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];

        [_collectionView registerClass:[WJBrandCollectionViewCell class] forCellWithReuseIdentifier:kBrandCollectionViewCellIdentifier];
        

    }
    return _collectionView;
}

- (APIBrandListManager *)brandListManager
{
    if (_brandListManager == nil) {
        _brandListManager = [[APIBrandListManager alloc]init];
        _brandListManager.delegate = self;
    }
    _brandListManager.shouldParse = YES;
    return _brandListManager;
}

- (NSMutableArray *)dataArray
{
    if(nil == _dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



@end
