//
//  WJMyCollectionViewController.m
//  HuPlus
//
//  Created by reborn on 16/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJMyCollectionViewController.h"
#import "WJHomeRecommendCollectionViewCell.h"
#import "WJSystemAlertView.h"
#import "APIMyCollectionManager.h"
#import "APIDeleteCollectionManager.h"
#import "WJRefreshCollectionView.h"
#import "WJMyCollectionModel.h"
#import "WJEmptyView.h"
#import "WJSegmentedView.h"
#import "WJProductDetailController.h"

#import "WJProductCollectionListController.h"
#import "WJShopCollectionListController.h"

#define kDefaultCellIdentifier              @"kDefaultCellIdentifier"
#define kCollectionCellIdentifier           @"kCollectionCellIdentifier"

@interface WJMyCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WJSystemAlertViewDelegate,APIManagerCallBackDelegate,WJSegmentedViewDelegate>
{
    NSInteger deleteIndex;
    BOOL      isShowDelete;
    
    BOOL      isHeaderRefresh;
    BOOL      isFooterRefresh;
    
//    UIScrollView   *baseScrollView;
//    WJProductCollectionListController *productCollectionListVC;
//    WJShopCollectionListController    *shopCollectionListVC;
    
    UIView         *noDataView;
    
    NSInteger      totalCount;
}

@property(nonatomic, strong)WJRefreshCollectionView     *collectionView;
//@property(nonatomic, strong)WJSegmentedView             *segmentedView;
@property(nonatomic, strong)APIMyCollectionManager      *myCollectionManager;
@property(nonatomic, strong)APIDeleteCollectionManager  *deleteCollectionManager;
@property(nonatomic, strong)NSMutableArray              *listArray;
@property(nonatomic, strong)WJMyCollectionModel         *myCollectionModel;
@property(nonatomic, strong)WJHomeGoodsModel            *deleteModel;

@end

@implementation WJMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    self.isHiddenTabBar = YES;
    isShowDelete = NO;
    [self.view addSubview:self.collectionView];
    
    [self navigationSetup];
    
    [self showLoadingView];
    self.myCollectionManager.shouldCleanData = YES;
    [self requestData];
    
//    baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, (kScreenHeight- kNavigationBarHeight))];
//    baseScrollView.pagingEnabled = YES;
//    baseScrollView.bounces = NO;
//    baseScrollView.scrollsToTop = NO;
//    baseScrollView.delegate = self;
//    baseScrollView.showsHorizontalScrollIndicator = NO;
//    [self.view addSubview:baseScrollView];
//    
//    productCollectionListVC = [[WJProductCollectionListController alloc] init];
//    productCollectionListVC.view.frame = CGRectMake(0, 0, kScreenWidth, baseScrollView.height);
//    [self addChildViewController:productCollectionListVC];
//    [productCollectionListVC didMoveToParentViewController:self];
//    [baseScrollView addSubview:productCollectionListVC.view];
//    
//    shopCollectionListVC = [[WJShopCollectionListController alloc] init];
//    shopCollectionListVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, baseScrollView.height);
//    [self addChildViewController:shopCollectionListVC];
//    [shopCollectionListVC didMoveToParentViewController:self];
//    [baseScrollView addSubview:shopCollectionListVC.view];
//    
//    baseScrollView.contentSize = CGSizeMake(2*kScreenWidth, baseScrollView.height);

    
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WJEmptyView *emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(86), kScreenWidth, ALD(140))];
    emptyView.tipLabel.text = @"您还没有收藏的商品";
    emptyView.imageView.image = [UIImage imageNamed:@"collection_nodata_image"];
    [noDataView addSubview:emptyView];
    noDataView.hidden = YES;
    [self.view addSubview:noDataView];
    
}

//- (void)navigationSetup
//{
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 19, 19);
//    [leftBtn setImage:[UIImage imageNamed:@"common_nav_btn_back"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(backBarButton:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:WJFont18,
//                                                                    NSForegroundColorAttributeName:WJColorNavigationBar};
//    
//    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight)];
//    rightView.backgroundColor = WJColorWhite;
//    
//    [rightView addSubview:self.segmentedView];
//    
//    UIButton  *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    editButton.frame = CGRectMake(kScreenWidth - ALD(30), 0, ALD(40), ALD(40));
//    editButton.titleLabel.font = WJFont14;
//    [rightView addSubview:editButton];
//
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
//    
//    if (isShowDelete) {
//        
//        [editButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
//        [editButton setTitle:@"完成" forState:UIControlStateNormal];
//        [editButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        
//    } else {
//        
//        [editButton setTitle:@"编辑" forState:UIControlStateNormal];
//        [editButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
//        [editButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//}

- (void)navigationSetup
{
    UIButton  *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(kScreenWidth - ALD(30), 0, ALD(40), ALD(40));
    editButton.titleLabel.font = WJFont14;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    if (isShowDelete) {
        
        [editButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [editButton setTitle:@"完成" forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        
        [editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [editButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    _segmentedView.selectedSegmentIndex = 0;
//    [self segmentedView:_segmentedView buttonClick:0];
}


#pragma mark - RequestData
- (void)requestData{
    
    self.myCollectionManager.currentPage = 1;
    [self.myCollectionManager loadData];
}

- (void)reloadMoreData{
    
    [self.myCollectionManager loadData];
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
    
    cell.deleteBlock = ^{
        
        WJSystemAlertView *alertView = [[WJSystemAlertView alloc] initWithTitle:@"提示" message:@"确定取消该收藏吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" textAlignment:NSTextAlignmentCenter];
        [alertView showIn];
        deleteIndex = indexPath.row;
    };
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
    } else {
    
        WJHomeGoodsModel *model = self.listArray[indexPath.row];
        WJProductDetailController * productDetailVC = [[WJProductDetailController alloc]init];
        productDetailVC.productId = model.productId;
        [self.navigationController pushViewController:productDetailVC animated:YES];
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

#pragma mark - WJSegmentedViewDelegate
//-(void)segmentedView:(WJSegmentedView *)segmentedView buttonClick:(NSInteger)index
//{
//    NSLog(@"点击第%ld个",(long)index);
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        baseScrollView.contentOffset = CGPointMake(kScreenWidth*index, 0);
//    }];
//    
//    switch (index) {
//        case 0:
//            [productCollectionListVC.collectionView startHeadRefresh];
//            break;
//            
//        case 1:
////            shopCollectionListVC
//            break;
//    
//            
//        default:
//            break;
//    }
//}
//
//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    CGPoint endpoint = scrollView.contentOffset;
//    NSInteger index = round(endpoint.x/kScreenWidth);
//    _segmentedView.selectedSegmentIndex = index;
//    
//    [self segmentedView:_segmentedView buttonClick:index];
//}

#pragma mark - Action
-(void)editButtonAction
{
    isShowDelete = YES;
    [self navigationSetup];
    [self.collectionView reloadData];
    
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDeleteStatus" object:nil userInfo:@{@"isShowDelete":@"YES"}];
}

-(void)finishButtonAction
{
    isShowDelete = NO;
    [self navigationSetup];
    [self.collectionView reloadData];

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDeleteStatus" object:nil userInfo:@{@"isShowDelete":@"NO"}];

}

//- (void)backBarButton:(UIButton *)btn{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)deleteAction
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//-(WJSegmentedView *)segmentedView
//{
//    if (!_segmentedView) {
//        _segmentedView = [[WJSegmentedView alloc] initWithFrame:CGRectMake((kScreenWidth - ALD(160))/2, 0, ALD(160), kNavigationBarHeight) items:@[@"商品",@"店铺"]];
//        [_segmentedView setBottomLineView:NO];
//        _segmentedView.delegate = self;
//    }
//    return _segmentedView;
//}

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
