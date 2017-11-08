//
//  WJThirdShopViewController.m
//  HuPlus
//
//  Created by reborn on 17/2/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJThirdShopViewController.h"
#import "WJRefreshTableView.h"
#import "WJThirdShopTopView.h"
#import "WJThirdShopListCell.h"
#import "WJHomeRecommendCollectionViewCell.h"
#import "WJThirdShopSectionCell.h"
#import "WJProductDetailController.h"
#import "APIThirdShopManager.h"
#import "WJThirdShopReformer.h"
#import "WJRefreshCollectionView.h"

#define kHeaderCellIdentifier            @"kHeaderCellIdentifier"
#define kRecommendCellIdentifier         @"kRecommendCellIdentifier"
#define kSectionHeaderCellIdentifier     @"kSectionHeaderCellIdentifier"
@interface WJThirdShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WJThirdShopSectionCellDelegate,APIManagerCallBackDelegate>
{
    BOOL      isHeaderRefresh;
    BOOL      isFooterRefresh;
    NSInteger totalPage;
}
@property(nonatomic,strong)WJRefreshCollectionView   *collectionView;
@property(nonatomic,strong)WJThirdShopTopView        *topView;
@property(nonatomic,strong)APIThirdShopManager       *thirdShopManager;
@property(nonatomic,strong)WJThirdShopDetailModel    *thirdShopDetailModel;
@property(nonatomic,assign)ThirdShopType             currentType;
@property(nonatomic,strong)NSMutableArray            *dataArray;
@end

@implementation WJThirdShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenTabBar = YES;
    self.isHiddenNavLine = YES;
    self.isWhiteNavItem = YES;
    self.ishiddenNav = YES;
    
    self.currentType = ThirdShopTypeRecommend;
    [self.view addSubview:self.collectionView];
    [self showLoadingView];
    [self requestData];
}

#pragma mark - RequestData
- (void)requestData{

    self.thirdShopManager.shouldCleanData = YES;
    self.thirdShopManager.currentPage = 1;
    [self.thirdShopManager loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshCollectionView *)collectionView
{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.thirdShopManager.shouldCleanData = YES;
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
            
        }
        [self.thirdShopManager loadData];
    }
    
}

- (void)startFootRefreshToDo:(WJRefreshCollectionView *)collectionView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        self.thirdShopManager.shouldCleanData = NO;
        [self.thirdShopManager loadData];

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
    self.thirdShopDetailModel  = [manager fetchDataWithReformer:[[WJThirdShopReformer alloc] init]];
    totalPage = self.thirdShopDetailModel.totalPage;
    
    if (self.dataArray == nil) {
        self.dataArray = self.thirdShopDetailModel.productListArray;
        
    } else {
        
        if (self.thirdShopManager.currentPage < totalPage) {
            
            [self.dataArray addObjectsFromArray:self.thirdShopDetailModel.productListArray];
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
        
        [self refreshFooterStatus:self.thirdShopManager.hadGotAllData];
        [self endGetData:NO];
    }
    
}

#pragma mark - CollectionViewDelegate/CollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
        
    } else {
        
        if (self.dataArray == nil || self.dataArray.count == 0) {
            
            return 0;
        }
        return self.dataArray.count;

    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHeaderCellIdentifier forIndexPath:indexPath];
        
        [self.topView configDataWithThirdShopDetailModel:self.thirdShopDetailModel];
        [cell addSubview:self.topView];
        return cell;

    }
    
    WJHomeRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendCellIdentifier forIndexPath:indexPath];
    [cell configDataWithModel:self.dataArray[indexPath.row]];

    return cell;

}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        if (indexPath.section != 0) {
            
            WJThirdShopSectionCell *sectionView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderCellIdentifier forIndexPath:indexPath];
            sectionView.delegate = self;
            
            reusableview = sectionView;
            
            return reusableview;
        }

        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderCellIdentifier forIndexPath:indexPath];
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return CGSizeMake(0, 0);
        
    } else {
        
        return CGSizeMake(kScreenWidth, ALD(50));
    }
    return CGSizeMake(0, 0);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return ALD(5);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth,ALD(150));
        
    } else {
        
        return CGSizeMake((kScreenWidth - ALD(10))/3, (kScreenWidth - ALD(10))/3 + ALD(75));
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WJProductDetailController * productDetailVC = [[WJProductDetailController alloc]init];
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

#pragma mark - WJThirdShopSectionCellDelegate
-(void)shopSectionView:(WJThirdShopSectionCell *)cell clickIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            self.currentType = ThirdShopTypeRecommend;
            NSLog(@"1");
        }
            break;
        case 1:
        {
            self.currentType = ThirdShopTypeHotSale;
            NSLog(@"2");
        }
            break;
        case 2:
        {
            self.currentType = ThirdShopTypeAll;
            NSLog(@"3");
        }
            break;
            
        default:
            break;
    }

    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
        
    }
    [self requestData];
}

#pragma mark - setter/getter
- (WJRefreshCollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[WJRefreshCollectionView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight - kStatusBarHeight, kScreenWidth, kScreenHeight + kAllBarHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = WJColorViewBg;

        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];


        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kHeaderCellIdentifier];

        [_collectionView registerClass:[WJHomeRecommendCollectionViewCell class] forCellWithReuseIdentifier:kRecommendCellIdentifier];
        
        [_collectionView registerClass:[WJThirdShopSectionCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderCellIdentifier];

    }
    return _collectionView;
}

-(WJThirdShopTopView *)topView
{
    if (_topView == nil) {
        _topView = [[WJThirdShopTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(150))];
    }
    return _topView;
}

-(APIThirdShopManager *)thirdShopManager
{
    if (_thirdShopManager == nil) {
        _thirdShopManager = [[APIThirdShopManager alloc] init];
        _thirdShopManager.delegate = self;
    }
    _thirdShopManager.shopId = self.shopId;
    _thirdShopManager.thirdShopType = self.currentType;
    _thirdShopManager.shouldParse = YES;
    return _thirdShopManager;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
