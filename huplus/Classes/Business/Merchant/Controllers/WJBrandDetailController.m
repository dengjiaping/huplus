//
//  WJBrandDetailController.m
//  HuPlus
//
//  Created by XT Xiong on 2017/1/11.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJBrandDetailController.h"
#import "WJBrandCell.h"
#import "WJHotRecommendCell.h"
#import "WJHomeRecommendCollectionViewCell.h"
#import "WJBrandDetailCell.h"
#import "APIBrandDetailManager.h"
#import "WJHotRecommendModel.h"
#import "WJBrandDetailModel.h"
#import "WJBrandDetailReformer.h"
#import "WJProductListController.h"
#import "WJProductDetailController.h"


@interface WJBrandDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,APIManagerCallBackDelegate>

@property(nonatomic,strong)UICollectionView           *mainCollectionView;
@property(nonatomic,strong)APIBrandDetailManager      *brandDetailManager;
@property(nonatomic,strong)WJBrandDetailModel         *brandDetailModel;
@property(nonatomic,strong)NSMutableArray             *dataArray;

@property(nonatomic,strong)WJBrandDetailCell          *brandDetailCell;
@property(nonatomic,strong)UILabel                    *titleLabel;


@end

static NSString *const kBrandIdentifier = @"kBrandIdentifier";
static NSString *const kBrandDetailIdentifier = @"kBrandDetailIdentifier";
static NSString *const kDetailIdentifier = @"kDetailIdentifier";
static NSString *const kHotRecIdentifier = @"kHotRecIdentifier";
static NSString *const kGoodsIdentifier = @"kGoodsIdentifier";

@implementation WJBrandDetailController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenTabBar = YES;
    [self.view addSubview:self.mainCollectionView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    _titleLabel.font = WJFont18;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = WJColorWhite;
    [self.view addSubview:_titleLabel];
    [self.view bringSubviewToFront:_titleLabel];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(15, 32, 22, 22);
    [leftBtn setImage:[UIImage imageNamed:@"common_nav_btn_back_white"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    [self.view bringSubviewToFront:leftBtn];
    

    
    [self showLoadingView];
    [self.brandDetailManager loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    self.brandDetailModel  = [manager fetchDataWithReformer:[[WJBrandDetailReformer alloc] init]];
    self.titleLabel.text = self.brandDetailModel.brandName;
    self.dataArray = self.brandDetailModel.listArray;
    [self.mainCollectionView reloadData];
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    ALERT(manager.errorMessage);
}

#pragma mark - CollectionViewDelegate/CollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 4) {
        return self.dataArray.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WJBrandCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrandIdentifier forIndexPath:indexPath];
        [cell configData:self.brandDetailModel];
        return cell;
    } else if (indexPath.section == 1){
        WJBrandDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrandDetailIdentifier forIndexPath:indexPath];
        self.brandDetailCell = cell;
        [cell configData:self.brandDetailModel];
        return cell;
    } else if (indexPath.section == 2){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailIdentifier forIndexPath:indexPath];
        cell.backgroundColor = WJColorViewBg;
        return cell;
    } else if(indexPath.section == 3){
        WJHotRecommendCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHotRecIdentifier forIndexPath:indexPath];
        [cell.moreButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    } else{
        
        WJHomeRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGoodsIdentifier forIndexPath:indexPath];
        cell.backgroundColor = WJColorWhite;
        
        [cell configDataWithModel:self.dataArray[indexPath.row]];
        
        return cell;
    }
}

- (void)buttonAction
{
    //推荐更多
    WJProductListController *productListVC = [[WJProductListController alloc] init];
    productListVC.brandId = self.brandId;
    productListVC.brandName = _brandDetailModel.brandName;
    productListVC.comeFormType = ComeFromTypeBrand;
    [self.navigationController pushViewController:productListVC animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [self.brandDetailCell changeLabelHight];
    }
    if (indexPath.section == 4) {
        //点击商品
        WJProductDetailController *productDetailVC = [[WJProductDetailController alloc]init];
        WJHomeGoodsModel *homeGoodsModel = self.dataArray[indexPath.row];
        productDetailVC.productId = homeGoodsModel.productId;
        [self.navigationController pushViewController:productDetailVC animated:YES];
        NSLog(@"点击%ld",indexPath.row);
    }
}




//item尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth,140);
    }else if (indexPath.section == 1){
        return CGSizeMake(kScreenWidth,70);
    }else if(indexPath.section == 2){
        return CGSizeMake(kScreenWidth,10);
    } else if(indexPath.section == 3){
        return CGSizeMake(kScreenWidth,40);
    } else {
        return CGSizeMake((kScreenWidth - ALD(10))/3, (kScreenWidth - ALD(10))/3 + ALD(75));
    }
}


#pragma mark - setter and getter
- (UICollectionView *)mainCollectionView
{
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, -kStatusBarHeight, kScreenWidth, kScreenHeight + kStatusBarHeight + kTabbarHeight) collectionViewLayout:layout];
        _mainCollectionView.backgroundColor = WJColorWhite;
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        
        //品牌
        [_mainCollectionView registerClass:[WJBrandCell class] forCellWithReuseIdentifier:kBrandIdentifier];
        
        //品牌详情
        [_mainCollectionView registerClass:[WJBrandDetailCell class] forCellWithReuseIdentifier:kBrandDetailIdentifier];
        
        //详情 & 间隔
        [_mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kDetailIdentifier];
        
        //热门推荐
        [_mainCollectionView registerClass:[WJHotRecommendCell class] forCellWithReuseIdentifier:kHotRecIdentifier];
        
        //商品橱窗
        [_mainCollectionView registerClass:[WJHomeRecommendCollectionViewCell class] forCellWithReuseIdentifier:kGoodsIdentifier];
    }
    return _mainCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(APIBrandDetailManager *)brandDetailManager
{
    if (!_brandDetailManager) {
        _brandDetailManager = [[APIBrandDetailManager alloc] init];
        _brandDetailManager.delegate = self;
    }
    _brandDetailManager.brandId = self.brandId;
    return _brandDetailManager;
}

@end
