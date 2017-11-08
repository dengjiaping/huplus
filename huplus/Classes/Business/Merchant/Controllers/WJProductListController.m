//
//  WJProductListController.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/26.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJProductListController.h"
#import "WJTitleButton.h"
#import "WJPriceListView.h"
#import "WJBrandListView.h"
#import "WJCategoryView.h"
#import "WJHomeRecommendCollectionViewCell.h"
#import "APIIndexFloorDetailManager.h"
#import "APIGoodsListConditionManager.h"
#import "APIGoodsListManager.h"
#import "WJGoodsListConditionReformer.h"
#import "WJGoodsListReformer.h"
#import "WJBrandListModel.h"
#import "WJPriceListModel.h"
#import "WJHomeGoodsModel.h"
#import "WJEmptyView.h"
#import "WJProductDetailController.h"

@interface WJProductListController ()<UICollectionViewDelegate,UICollectionViewDataSource,APIManagerCallBackDelegate>
{
    WJTitleButton * brandButton;
    WJTitleButton * categoryButton;
    WJTitleButton * priceButton;
    
    NSString      * selectBrandID;
    NSString      * selectCategoryID;
    NSString      * selectMinPrice;
    NSString      * selectMaxPrice;
    
    UIView        *noDataView;
    WJEmptyView   *emptyView;

}

@property(nonatomic,strong)UIView                       * guidanceView;
@property(nonatomic,strong)WJBrandListView              * brandTableView;
@property(nonatomic,strong)WJPriceListView              * priceTableView;
@property(nonatomic,strong)WJCategoryView               * categoryView;

@property(nonatomic,strong)UICollectionView             * mainCollectionView;
@property(nonatomic,strong)NSMutableArray               * dataArray;
@property(nonatomic,strong)NSString                     * totalPage;

@property(nonatomic,strong)APIIndexFloorDetailManager   * indexFloorDetailManager;
@property(nonatomic,strong)APIGoodsListConditionManager * goodsListConditionManager;
@property(nonatomic,strong)APIGoodsListManager          * goodsListManager;

@end

@implementation WJProductListController

#pragma mark - Life Ciryle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品列表";
    self.isHiddenTabBar = YES;
    self.navigationController.navigationBarHidden = NO;

    [self setComeFromOfUIAndLogic];
    
    [self.view addSubview:self.mainCollectionView];
    
    [self.view addSubview:self.brandTableView];
    [self.view addSubview:self.priceTableView];
    [self.view addSubview:self.categoryView];
    
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    noDataView.hidden = YES;
    emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(86), kScreenWidth, ALD(140))];
    emptyView.tipLabel.text = @"没有相关的商品";
    emptyView.imageView.image = [UIImage imageNamed:@"search_nodata_image"];
    emptyView.hidden = YES;
    [noDataView addSubview:emptyView];
    [self.view addSubview:emptyView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCategoryButtonTittle:) name:@"kCategoryButtonRefresh" object:nil];

}

- (void)dealloc
{
    [kDefaultCenter removeObserver:self];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    NSLog(@"%@",manager.errorMessage);
    if ([manager isKindOfClass:[APIGoodsListConditionManager class]]) {
        NSMutableDictionary * dataDic = [manager fetchDataWithReformer:[[WJGoodsListConditionReformer alloc]init]];
        self.brandTableView.dataArray = dataDic[@"brand_list"];
        [self.brandTableView.mainTableView reloadData];
        self.categoryView.dataArray = dataDic[@"category_list"];
        [self.categoryView.mainTableView reloadData];
        self.priceTableView.dataArray = dataDic[@"price_list"];
        [self.priceTableView.mainTableView reloadData];
        
    }else if ([manager isKindOfClass:[APIGoodsListManager class]]) {
        NSMutableDictionary * dataDic = [manager fetchDataWithReformer:[[WJGoodsListReformer alloc]init]];
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
        self.dataArray = dataDic[@"goods_list"];
        self.totalPage = dataDic[@"total_page"];
        [self.mainCollectionView reloadData];
        
        if (self.dataArray.count != 0) {
            noDataView.hidden = YES;
            emptyView.hidden = YES;
        } else {
            noDataView.hidden = NO;
            emptyView.hidden = NO;
        }
        
    }else if ([manager isKindOfClass:[APIIndexFloorDetailManager class]]) {
        NSMutableDictionary * dataDic = [manager fetchDataWithReformer:[[WJGoodsListReformer alloc]init]];
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
        self.dataArray = dataDic[@"goods_list"];
        self.totalPage = dataDic[@"total_page"];
        [self.mainCollectionView reloadData];
        
        
        if (self.dataArray.count != 0) {
            noDataView.hidden = YES;
            emptyView.hidden = YES;
        } else {
            noDataView.hidden = NO;
            emptyView.hidden = NO;
        }

    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"%@",manager.errorMessage);
}

#pragma mark - Button Action
- (void)brandClick:(UIButton *)button
{
    noDataView.hidden = YES;
    emptyView.hidden = YES;
    
    button.selected = !button.selected;
    [self button:button buttonIsSelect:YES];
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

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
    WJHomeRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"categoryCell" forIndexPath:indexPath];
    WJHomeGoodsModel *homeGoodsModel = self.dataArray[indexPath.row];
    [cell configDataWithModel:homeGoodsModel];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (iPhone6OrThan) {
        return CGSizeMake((kScreenWidth - ALD(5))/2, (kScreenWidth - ALD(5))/2 + ALD(75));
    }else{
        return CGSizeMake((kScreenWidth - ALD(6))/2, (kScreenWidth - ALD(6))/2 + ALD(75));
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return ALD(5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击分类第%ld个cell",(long)indexPath.row);
    WJHomeGoodsModel *productModel = self.dataArray[indexPath.row];
    WJProductDetailController * productDetailVC = [[WJProductDetailController alloc]init];
    productDetailVC.productId = productModel.productId;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

#pragma mark - Custom Founction
- (void)setComeFromOfUIAndLogic
{
    if (self.comeFormType == ComeFromTypeBrand) {
        self.isHiddenNavLine = YES;
        [self.goodsListConditionManager loadData];
        [self.view addSubview:self.guidanceView];
        [brandButton setTitle:self.brandName forState:UIControlStateNormal];
        selectBrandID = self.brandId;
    }else if (self.comeFormType == ComeFromTypeHomeCategory) {
        self.isHiddenNavLine = YES;
        [self.goodsListConditionManager loadData];
        [self.view addSubview:self.guidanceView];
        if (self.homeCategoryListModel) {
            [categoryButton setTitle:_homeCategoryListModel.categoryName forState:UIControlStateNormal];
            selectCategoryID = _homeCategoryListModel.categoryId;
        }
        
    }else if (self.comeFormType == ComeFromTypeHomeMore){
        [self.indexFloorDetailManager loadData];
        return;
        
    }else if (self.comeFormType == ComeFromTypeSearch){
        self.isHiddenNavLine = YES;
        self.title = self.condition;
        self.goodsListManager.condition = self.condition;
        [self.goodsListConditionManager loadData];
        [self.view addSubview:self.guidanceView];
        
    }else if (self.comeFormType == ComeFromTypeThirdShop){
        self.isHiddenNavLine = YES;
        self.goodsListManager.storeId = self.storeId;
        [self.goodsListConditionManager loadData];
        [self.view addSubview:self.guidanceView];
    }else {
        
        [self.indexFloorDetailManager loadData];
        return;
    }
    [self showLoadingView];
    [self goodsListManagerRequest];
}

- (void)goodsListManagerRequest
{
    self.goodsListManager.categoryId = selectCategoryID;
    self.goodsListManager.brandId = selectBrandID;
    self.goodsListManager.minPrice = selectMinPrice;
    self.goodsListManager.maxprice = selectMaxPrice;
    [self.goodsListManager loadData];
}

- (void)button:(UIButton *)button buttonIsSelect:(BOOL)isSelect
{
    NSInteger buttonTag = button.tag - 12000;
    CGPoint center;
    if (buttonTag == 0) {
        if (isSelect) {
            categoryButton.selected = NO;
            priceButton.selected = NO;
            self.brandTableView.hidden = !button.selected;
            self.categoryView.hidden = !categoryButton.selected;
            self.priceTableView.hidden = !priceButton.selected;
        }
        center.y = _guidanceView.center.y;
        center.x = _guidanceView.center.x/3;
        button.center = center;
    }else if (buttonTag == 1){
        if (isSelect) {
            brandButton.selected = NO;
            priceButton.selected = NO;
            self.brandTableView.hidden = !brandButton.selected;
            self.categoryView.hidden = !button.selected;
            self.priceTableView.hidden = !priceButton.selected;
            
            
            //顶部分类默认列表
            WJCategoryListModel *rootCategoryModel = [self getRootCategoryModel];
            self.categoryView.collecDataArray = rootCategoryModel.childListArray;
            [self.categoryView.mainCollectionView reloadData];
            
            //左侧分类列默认选中
            [self.categoryView changeSelectStatus:rootCategoryModel];
            
        }
        button.center = _guidanceView.center;
    }else{
        if (isSelect) {
            categoryButton.selected = NO;
            brandButton.selected = NO;
            self.brandTableView.hidden = !brandButton.selected;
            self.categoryView.hidden = !categoryButton.selected;
            self.priceTableView.hidden = !button.selected;
        }
        center.y = _guidanceView.center.y;
        center.x = (_guidanceView.center.x/3)*2 + _guidanceView.center.x;
        button.center = center;
    }
}

-(void)refreshCategoryButtonTittle:(NSNotification *)notification
{
    WJTitleButton *categorybutton = (WJTitleButton *)[self.view viewWithTag:12001];

    [categorybutton setTitle:notification.userInfo[@"categoryName"] forState:UIControlStateNormal];
}


-(WJCategoryListModel *)getRootCategoryModel
{
    for (int i = 1; i<
         self.categoryView.dataArray.count; i++)
    {
        WJCategoryListModel *categoryListModel = [[WJCategoryListModel alloc] init];
        categoryListModel = self.categoryView.dataArray[i];
        
        for (int i = 0; i<categoryListModel.childListArray.count; i++)
        {
            WJCategoryListModel *middleListModel = [[WJCategoryListModel alloc] init];
            middleListModel = categoryListModel.childListArray[i];

            for (int i = 0; i<middleListModel.childListArray.count; i++)
            {
                WJCategoryListModel *childListModel = [[WJCategoryListModel alloc] init];
                childListModel = middleListModel.childListArray[i];
                
                if ([childListModel.categoryId isEqualToString:self.homeCategoryListModel.categoryId]) {
                    return categoryListModel;
                }
            }
        }
    }

    return nil;
}


#pragma mark - Setter And Getter
- (UICollectionView *)mainCollectionView
{
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsZero;
        if (self.comeFormType == ComeFromTypeHomeMore) {
            //不需要筛选条样式
            _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , kScreenHeight - kNavBarAndStatBarHeight) collectionViewLayout:layout];
        }else {
            _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth , kScreenHeight - kNavBarAndStatBarHeight - 40) collectionViewLayout:layout];
        }
        _mainCollectionView.backgroundColor = WJColorWhite;
        
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        
        [_mainCollectionView registerClass:[WJHomeRecommendCollectionViewCell class] forCellWithReuseIdentifier:@"categoryCell"];
    }
    return _mainCollectionView;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIView *)guidanceView
{
    if (_guidanceView == nil) {
        _guidanceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _guidanceView.backgroundColor = WJColorWhite;
        
        brandButton = [[WJTitleButton alloc] init];
        brandButton.tag = 12000;
        [brandButton setTitle:@"全部品牌" forState:UIControlStateNormal];
        [brandButton addTarget:self action:@selector(brandClick:) forControlEvents:UIControlEventTouchUpInside];
        [self button:brandButton buttonIsSelect:NO];
        [_guidanceView addSubview:brandButton];
        
        categoryButton = [[WJTitleButton alloc] init];
        categoryButton.tag = 12001;
        [categoryButton setTitle:@"全部分类" forState:UIControlStateNormal];
        [categoryButton addTarget:self action:@selector(brandClick:) forControlEvents:UIControlEventTouchUpInside];
        [self button:categoryButton buttonIsSelect:NO];
        [_guidanceView addSubview:categoryButton];

        priceButton = [[WJTitleButton alloc] init];
        priceButton.tag = 12002;
        [priceButton setTitle:@"全部价格" forState:UIControlStateNormal];
        [priceButton addTarget:self action:@selector(brandClick:) forControlEvents:UIControlEventTouchUpInside];
        [self button:priceButton buttonIsSelect:NO];
        [_guidanceView addSubview:priceButton];
        
        UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, kScreenWidth, 0.5)];
        bottomLine.backgroundColor = WJColorSeparatorLine;
        [_guidanceView addSubview:bottomLine];
    }
    return _guidanceView;
}

- (WJPriceListView *)priceTableView
{
    if (_priceTableView == nil) {
        _priceTableView = [[WJPriceListView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 40 - kNavBarAndStatBarHeight)];
        _priceTableView.backgroundColor = WJColorDarkGray;
        _priceTableView.hidden = YES;
        __block typeof(self) blockSelf = self;
        _priceTableView.priceListBlock = ^(WJPriceListModel * priceListModel){
            blockSelf->selectMinPrice = priceListModel.minPrice;
            blockSelf->selectMaxPrice = priceListModel.maxPrice;
            if ([priceListModel.minPrice isEqualToString:@""]&&[priceListModel.maxPrice isEqualToString:@""]) {
                NSString * titleStr = @"全部价格";
                [blockSelf->priceButton setTitle:titleStr forState:UIControlStateNormal];
            }else{
                NSString * titleStr = [NSString stringWithFormat:@"￥%@-%@",priceListModel.minPrice,priceListModel.maxPrice];
                [blockSelf->priceButton setTitle:titleStr forState:UIControlStateNormal];
            }
            blockSelf->priceButton.selected = NO;
            blockSelf.priceTableView.hidden = YES;
            //文字对齐
            [blockSelf button:blockSelf->priceButton buttonIsSelect:NO];
            [blockSelf goodsListManagerRequest];
        };
    }
    return _priceTableView;
}

- (WJBrandListView *)brandTableView
{
    if (_brandTableView == nil) {
        _brandTableView = [[WJBrandListView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 40 - kNavBarAndStatBarHeight)];
        _brandTableView.backgroundColor = WJColorDarkGray;
        _brandTableView.hidden = YES;
        __block typeof(self) blockSelf = self;
        _brandTableView.brandListBlock = ^(WJBrandListModel * brandListModel){
            blockSelf->selectBrandID = brandListModel.brandId;
            [blockSelf->brandButton setTitle:brandListModel.brandName forState:UIControlStateNormal];
            blockSelf->brandButton.selected = NO;
            blockSelf.brandTableView.hidden = YES;
            //文字对齐
            [blockSelf button:blockSelf->brandButton buttonIsSelect:NO];
            [blockSelf goodsListManagerRequest];
        };
    }
    return _brandTableView;
}

- (WJCategoryView *)categoryView
{
    if (_categoryView == nil) {
        _categoryView = [[WJCategoryView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 40 - kNavBarAndStatBarHeight)];
        _categoryView.backgroundColor = WJColorDarkGray;
        _categoryView.categoryFrom = CategoryFromSingle;
        _categoryView.hidden = YES;
        __block typeof(self) blockSelf = self;
        _categoryView.categoryListSelectBlock = ^(WJCategoryListModel *categoryListModel){
            blockSelf->selectCategoryID = categoryListModel.categoryId;
            [blockSelf->categoryButton setTitle:categoryListModel.categoryName forState:UIControlStateNormal];
            blockSelf->categoryButton.selected = NO;
            blockSelf.categoryView.hidden = YES;
            [blockSelf button:blockSelf->categoryButton buttonIsSelect:NO];
            [blockSelf goodsListManagerRequest];
        };
    }
    return _categoryView;
}

- (APIIndexFloorDetailManager *)indexFloorDetailManager
{
    if (_indexFloorDetailManager == nil) {
        _indexFloorDetailManager = [[APIIndexFloorDetailManager alloc]init];
        _indexFloorDetailManager.delegate = self;
    }
    _indexFloorDetailManager.floorId = self.floorId;
    return _indexFloorDetailManager;
}

- (APIGoodsListConditionManager *)goodsListConditionManager
{
    if (_goodsListConditionManager == nil) {
        _goodsListConditionManager = [[APIGoodsListConditionManager alloc]init];
        _goodsListConditionManager.delegate = self;
    }
    return _goodsListConditionManager;
}

- (APIGoodsListManager *)goodsListManager
{
    if (_goodsListManager == nil) {
        _goodsListManager = [[APIGoodsListManager alloc]init];
        _goodsListManager.delegate = self;
        _goodsListManager.currentPage = @"1";
        _goodsListManager.pageSize = @"20";
    }
    return _goodsListManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
