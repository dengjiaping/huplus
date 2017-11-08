//
//  WJHomeViewController.m
//  HuPlus
//
//  Created by reborn on 2016/12/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJHomeViewController.h"
#import "WJCategoryCollectionViewCell.h"
#import "WJHomeMoreCollectionViewCell.h"
#import "WJHotBrandCollectionViewCell.h"
#import "WJHomeRecommendCollectionViewCell.h"
#import "WJSearchViewController.h"
#import "WJCustomBannerView.h"
#import "WJProductDetailController.h"
#import "WJScanViewController.h"
#import "WJScanCodeLoginViewController.h"
#import "WJBrandDetailController.h"
#import "UINavigationBar+Awesome.h"
#import "WJProductListController.h"
#import "WJCategoryViewController.h"
#import "WJBrandViewController.h"
#import "APIHomeTopManager.h"
#import "APIHomeBottomManager.h"
#import "WJHomeTopViewReformer.h"
#import "WJHomeBannerModel.h"
#import "WJWebViewController.h"
#import "WJThirdShopViewController.h"
#import "WJRecommendReformer.h"
#import "WJHotRecommendModel.h"
#import "WJAdvertiseView.h"
#import "WJAdvertiseListModel.h"
#import "WJAdvertiseModel.h"
#import "WJHomeSpaceCollectionViewCell.h"
#import "WJEmptyView.h"
#import <AdSupport/AdSupport.h>
#import "WJRefreshCollectionView.h"
#import "SDCycleScrollView.h"


#define kDefaultIdentifier              @"kDefaultIdentifier"
#define kBannerIdentifier               @"kBannerIdentifier"
#define kCategoryIdentifier             @"kCategoryIdentifier"
#define kBrandIdentifier                @"kBrandIdentifier"
#define kRecommendIdentifier            @"kRecommendIdentifier"
#define kMoreCollectionViewIdentifier   @"kMoreCollectionViewIdentifier"
#define kSpaceCellIdentifier            @"kSpaceCellIdentifier"

#define NavigationBarHight  64.0f
#define bannerHeight         ALD(224)

@interface WJHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WJHomeMoreCollectionViewCellDelegate,WJHotBrandCollectionViewCellDelegate,UISearchBarDelegate,APIManagerCallBackDelegate,WJAdvertiseViewDelegate,SDCycleScrollViewDelegate>
{
    CGFloat         alpha;
    UIColor         *color;
    UIButton        *scanButton;
    BOOL            isHeaderRefresh;
    BOOL            isFooterRefresh;
}
@property(nonatomic, strong)WJRefreshCollectionView  *collectionView;
@property(nonatomic, strong)UISearchBar              *searchBar;
@property(nonatomic, strong)WJCustomBannerView       *bannerView;
@property(nonatomic, strong)SDCycleScrollView        *cycleScrollView;


@property(nonatomic, strong)APIHomeTopManager        *homeTopManager;
@property(nonatomic, strong)APIHomeBottomManager     *homeBottomManager;

@property(nonatomic, strong)NSMutableArray           *bannerArray;    //轮播
@property(nonatomic, strong)NSMutableArray           *categoryArray;  //分类
@property(nonatomic, strong)WJAdvertiseListModel     *advertiseListModel; //广告

@property(nonatomic, strong)NSMutableArray           *brandArray;     //品牌
@property(nonatomic, strong)NSMutableArray           *recommendArray; //推荐

@end

@implementation WJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavLine = YES;
    color = WJColorWhite;
    alpha = 0;

//    [self readCacheBannerData];
    [self navigationSetup];
    [self.view addSubview:self.collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeData) name:kTabHomeRefresh object:nil];

    [self requestData];
}

- (void)dealloc
{
    [kDefaultCenter removeObserver:self];
}

-(void)refreshHomeData
{
    [self cleanTopViewData];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    if (_bannerView) {
        [_bannerView startTimer];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_bannerView pasueTimer];
}

-(void)requestData
{
    [self showLoadingView];
    [self.homeTopManager loadData];
}

- (void)navigationSetup
{
    scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = CGRectMake(0, 0, ALD(21), ALD(21));
    [scanButton setImage:[UIImage imageNamed:@"Home_saoyisao_white"] forState:UIControlStateNormal];
    
    [scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:scanButton];
    
    self.navigationItem.titleView = self.searchBar;
    
}

#pragma mark - WJRefreshCollectionView Delegate

- (void)startHeadRefreshToDo:(WJRefreshCollectionView *)collectionView
{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.homeTopManager.shouldCleanData = YES;
        [self cleanTopViewData];
        [self requestData];
    }
    
}
- (void)endGetData:(BOOL)needReloadData{
    
    if (isHeaderRefresh) {
        isHeaderRefresh = NO;
        [self.collectionView endHeadRefresh];
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
    
    if ((self.bannerArray == nil || self.bannerArray.count == 0) && (self.categoryArray == nil || self.categoryArray.count == 0) && (self.brandArray == nil || self.brandArray.count == 0) && (self.advertiseListModel.picListArray == nil || self.advertiseListModel.picListArray.count == 0)) {
        
        self.noNetWorkView.hidden = NO;
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        [scanButton setImage:[UIImage imageNamed:@"Home_saoyisao_dark"] forState:UIControlStateNormal];
    }
    
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    if ([manager isKindOfClass:[APIHomeTopManager class]]) {
        
        NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:[manager fetchDataWithReformer:[[WJHomeTopViewReformer alloc] init]]];
        self.bannerArray = dataDic[@"bannerArray"];
        self.categoryArray = dataDic[@"categoriesArray"];
        self.brandArray = dataDic[@"brandArray"];
        self.advertiseListModel = [[WJAdvertiseListModel alloc] initWithDic:dataDic[@"advertiseDic"]];
        
        [self endGetData:YES];
        [self refreshFooterStatus:manager.hadGotAllData];
        
        [self.homeBottomManager loadData];

    
    } else if ([manager isKindOfClass:[APIHomeBottomManager class]]) {
        
        self.recommendArray = [manager fetchDataWithReformer:[[WJRecommendReformer alloc] init]];
        
        [self.collectionView reloadData];
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIHomeTopManager class]]) {
        
        if (manager.errorType == APIManagerErrorTypeNoData) {
            [self refreshFooterStatus:YES];
            
            if (isHeaderRefresh) {

                [self cleanTopViewData];
                [self endGetData:YES];
                return;
            }
            [self endGetData:NO];
            
        } else {
            
            [self refreshFooterStatus:self.homeTopManager.hadGotAllData];
            [self endGetData:NO];
        }
    }
}

-(void)cleanTopViewData
{
    if (self.bannerArray.count > 0) {
        [self.bannerArray removeAllObjects];
        
    }
    if (self.categoryArray.count > 0) {
        [self.categoryArray removeAllObjects];
    }
    
    if (self.advertiseListModel.picListArray.count > 0) {
        [self.advertiseListModel.picListArray removeAllObjects];
    }
    if (self.brandArray.count > 0) {
        [self.brandArray removeAllObjects];
    }
}

#pragma mark - readFromLocalFile
- (NSString *)rootBannerPicUrlCachePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path firstObject];
    filePath = [filePath stringByAppendingPathComponent:@"LocalBanner.txt"];
    return filePath;
}

- (void)readCacheBannerData
{
    NSData *data  = [NSData dataWithContentsOfFile:[self rootBannerPicUrlCachePath]];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.bannerArray = array;
}

#pragma mark - CollectionViewDelegate/CollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.bannerArray.count > 0 && self.categoryArray.count > 0 &&  self.brandArray.count > 0 &&  self.advertiseListModel.picListArray.count > 0) {
        return 4 + self.recommendArray.count;

    }
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            
            return 1;
        }
            break;
            
        case 1:
        {
            if (self.categoryArray == nil || self.categoryArray.count == 0) {
                return 0;
            } else {
                if (self.categoryArray.count >= 8) {
                    return 8;
                } else {
                    return self.categoryArray.count;
                }
            }
            
        }
            break;
            
        case 2:
        {
            if (self.advertiseListModel.picListArray.count > 0 && [self.advertiseListModel.advertiseType hasPrefix:@"app_special"]) {
                
                return 1;
                
            } else {
                return 0;
            }
        }
            break;

            
        case 3:
        {
            if (self.brandArray == nil || self.brandArray.count == 0) {
                return 0;
                
            } else {
                return 1;
            }
        }
            
            break;
            
            
        default:
        {
            WJHotRecommendModel *hotRecommendModel = self.recommendArray[section - 4];
            
            if (hotRecommendModel.productListArray == nil || hotRecommendModel.productListArray.count == 0) {
                return 0;
                
            } else {
                
                if (hotRecommendModel.productListArray.count >= 3) {
                    
                    return 3;
                    
                } else {
                    return hotRecommendModel.productListArray.count;
                    
                }
            }
        }
            break;
            
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    
    if (section == 0) {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDefaultIdentifier forIndexPath:indexPath];

        __weak typeof(self) weakSelf = self;
        
        if (self.bannerArray.count > 0) {
            _bannerView = [WJCustomBannerView CreateBannerViewWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(224)) imageArray:self.bannerArray timerWithTimeInterval:1 imageClickBlock:^(NSInteger imageIndex) {
                __strong typeof(self) strongSelf = weakSelf;
                
                [strongSelf bannerClickIndex:imageIndex];
            }];
        }

        _bannerView.pageControlAlignment=NSPageControlAlignmentCenter;
        [cell.contentView addSubview:_bannerView];
//        [cell.contentView addSubview:self.cycleScrollView];
        return cell;
        
    } else if (section == 1) {
        WJCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategoryIdentifier forIndexPath:indexPath];
        if (indexPath.row == 7) {
            [cell moreCellData];
        } else {
            [cell conFigData:self.categoryArray[indexPath.row]];
        }
        return cell;
        
    } else if (section == 2) {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDefaultIdentifier forIndexPath:indexPath];

        WJAdvertiseView *advertiseView = [[WJAdvertiseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(160)) UIType:self.advertiseListModel.advertiseType];
        advertiseView.delegate = self;
        [advertiseView configDataWithArray:self.advertiseListModel.picListArray];
        [cell.contentView addSubview:advertiseView];
        
        return cell;
        
    } else if (section == 3) {
        
        WJHotBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrandIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        [cell hotBrandCellLoadDataWithArray:self.brandArray];
        return cell;
        
    } else {
        
        WJHomeRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendIdentifier forIndexPath:indexPath];

        WJHotRecommendModel *hotRecommendModel = self.recommendArray[indexPath.section - 4];
        [cell configDataWithModel:hotRecommendModel.productListArray[indexPath.row]];
        return cell;
    }
    

}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        if (indexPath.section == 2) {
            
            WJHomeSpaceCollectionViewCell *spaceCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSpaceCellIdentifier forIndexPath:indexPath];
            return spaceCell;
        }
        
        if (indexPath.section == 3) {
            
            WJHomeMoreCollectionViewCell *moreView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMoreCollectionViewIdentifier forIndexPath:indexPath];
            moreView.backgroundColor = WJColorViewBg;
            moreView.title = @"热门品牌";
            moreView.tag = 4008;
            moreView.delegate = self;
            return moreView;
            
        } else if (indexPath.section >= 4) {
            
            WJHotRecommendModel *hotRecommendModel = self.recommendArray[indexPath.section - 4];
            
            if (hotRecommendModel.productListArray.count > 0) {
                
                WJHomeMoreCollectionViewCell *moreView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMoreCollectionViewIdentifier forIndexPath:indexPath];
                moreView.backgroundColor = WJColorWhite;
                moreView.title = hotRecommendModel.recommendName;
                moreView.section = indexPath.section;
                moreView.tag = 4009;
                moreView.delegate = self;
                return moreView;
            }
        }
        
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMoreCollectionViewIdentifier forIndexPath:indexPath];
        
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;

    if (section == 0) {
        return CGSizeMake(kScreenWidth,kScreenWidth * 0.6);

    } else if (section == 1) {
        //分类
        return CGSizeMake(kScreenWidth/4, ALD(80));

    } else if (section == 2) {
        //广告位
        return CGSizeMake(kScreenWidth , ALD(160));

    }  else if (section == 3) {
        //热门品牌
        return CGSizeMake(kScreenWidth , 60);
        
    } else {
        
        return CGSizeMake((kScreenWidth - ALD(10))/3, (kScreenWidth - ALD(10))/3 + ALD(75));

    }
    return CGSizeMake(kScreenWidth,ALD(224));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);

    } else if (section == 1) {
        
        return UIEdgeInsetsMake(0, 0, 0, 0);

    } else if (section == 2) {
        
        return UIEdgeInsetsMake(0, 0, 0, 0);

    }  else if (section == 3) {
        
        return UIEdgeInsetsMake(0, 0, 0, 0);
        
    } else {
        
        return UIEdgeInsetsMake(0, 0, 0, 0);

    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 0.f;
        
    } else if (section == 1) {
        
        return 0;
        
    } else if (section == 2) {
        
        return 0;
        
    }  else if (section == 3) {
        
        return 0;
        
    } else {
        
        return ALD(5);

    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 0.f;
    } else if (section == 1) {
        
        return 0.f;

    } else if (section == 2) {
        
        return 0.f;
    } else if (section == 3) {
        
        return 0.f;
        
    } else {
        return 0.f;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return CGSizeMake(0, 0);

    } else if (section == 1) {
        
        return CGSizeMake(0, 0);


    } else if (section == 2) {
        
        return CGSizeMake(kScreenWidth, ALD(10));

        
    }  else if (section == 3) {
        
//        return CGSizeMake(kScreenWidth, ALD(44));
        return CGSizeMake(kScreenWidth, ALD(50));

        
    } else {
        
        return CGSizeMake(kScreenWidth, ALD(50));
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    
    if (section == 1) {
        //分类
        [MobClick event:[NSString stringWithFormat:@"sy_fl%ld",indexPath.row+1]];
        
        //分类更多
        if (indexPath.row == 7) {
            WJCategoryViewController * categoryVC = [[WJCategoryViewController alloc] init];
            [self.navigationController pushViewController:categoryVC animated:YES];
            
        } else {
            //分类商品列表
            WJCategoryListModel * categoryListModel = self.categoryArray[indexPath.row];
            
            WJProductListController * productListVC = [[WJProductListController alloc] init];
            productListVC.comeFormType = ComeFromTypeHomeCategory;
            productListVC.homeCategoryListModel = categoryListModel;
            [self.navigationController pushViewController:productListVC animated:YES];
            
        }
        
    } else {
        if (section > 0) {
            //楼层商品详情
            [MobClick event:[NSString stringWithFormat:@"sy_tj%ld",indexPath.row+1+3*(section-4)]];

            WJHotRecommendModel *hotRecommendModel = self.recommendArray[indexPath.section - 4];
            WJHomeGoodsModel *productModel = hotRecommendModel.productListArray[indexPath.row];
            
            WJProductDetailController * productDetailVC = [[WJProductDetailController alloc]init];
            productDetailVC.productId = productModel.productId;
            [self.navigationController pushViewController:productDetailVC animated:YES];
        }

    }

}

#pragma mark  - WJHotBrandCollectionViewCellDelegate
- (void)hotBrandCollectionViewCellDelegateSelectWithModel:(WJBrandModel *)hotBrandSelectModel
{
    WJBrandDetailController *brandDetailVC = [[WJBrandDetailController alloc] init];
    brandDetailVC.brandId = hotBrandSelectModel.brandID;
    [self.navigationController pushViewController:brandDetailVC animated:YES];
}


#pragma mark -  WJHomeMoreCollectionViewCellDelegate
-(void)moreCollectionViewCellWithClickMore:(WJHomeMoreCollectionViewCell *)homeMoreCollectionViewCell section:(NSInteger)section
{
    //品牌更多
    if (homeMoreCollectionViewCell.tag == 4008) {
        [MobClick event:@"sy_gd1"];
        
        WJBrandViewController *brandVC = [[WJBrandViewController alloc] init];
        [self.navigationController pushViewController:brandVC animated:YES];
        
        
    } else if (homeMoreCollectionViewCell.tag == 4009) {
        //推荐更多
        [MobClick event:[NSString stringWithFormat:@"sy_gd%ld",section-2]];
        
        WJProductListController *productListVC = [[WJProductListController alloc] init];
        WJHotRecommendModel *hotRecommendModel = self.recommendArray[section - 4];
        productListVC.floorId = hotRecommendModel.floorId;
        productListVC.comeFormType = ComeFromTypeHomeMore;
        [self.navigationController pushViewController:productListVC animated:YES];
    }
}

#pragma mark - WJAdvertiseViewDelegate
-(void)clickAdvertiseWithIndex:(NSInteger)index
{
    [MobClick event:[NSString stringWithFormat:@"sy_ad%ld",index+1]];
    
    NSLog(@"点击第%ld个广告",index);
    
    WJAdvertiseModel *selectModel = [[WJAdvertiseModel alloc] init];
    
    for (WJAdvertiseModel *advertiseModel in self.advertiseListModel.picListArray) {
        
        if (index + 1 == advertiseModel.positonNumber) {
            
            selectModel = advertiseModel;
            
        }
    }
    
    NSInteger advertiseType = [selectModel.linkType integerValue];
    
    switch (advertiseType) {
        case 1://H5
        {
            WJWebViewController *webVC = [[WJWebViewController alloc] init];
            [webVC loadWeb:selectModel.linkUrl];
            webVC.titleStr = @"活动详情";
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 2://店铺
        {
            WJThirdShopViewController *thirdShopVC = [[WJThirdShopViewController alloc] init];
            thirdShopVC.shopId = selectModel.linkUrl;
            [self.navigationController pushViewController:thirdShopVC animated:YES];
            
        }
            break;
        case 3://商品详情
        {
            WJProductDetailController * productDetailVC = [[WJProductDetailController alloc]init];
            productDetailVC.productId = selectModel.linkUrl;
            [self.navigationController pushViewController:productDetailVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }

}
#pragma mark - SDCycleScrollViewDelegate
//轮播选中代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
}

#pragma mark -  UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_searchBar becomeFirstResponder];
    [self handletapPressGesture];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

#pragma mark - WJNoNetWorkViewDelegate
-(void)clickRefreshButton
{
    [self showLoadingView];
    [self.homeTopManager loadData];
    self.noNetWorkView.hidden = YES;
}

#pragma mark -Action
- (void)scanAction:(id)sender
{
    [MobClick event:@"erweima"];
    
    WJScanViewController *scanVC = [[WJScanViewController alloc] init];
    [self.navigationController pushViewController:scanVC animated:YES];

}

- (void)handletapPressGesture
{
    [MobClick event:@"search"];
    
    WJSearchViewController *searchVC = [[WJSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

-(void)bannerClickIndex:(NSInteger)index
{
    [MobClick event:[NSString stringWithFormat:@"banner%ld",(long)index+1]];
    
    WJHomeBannerModel *bannerModel = self.bannerArray[index];
    
    NSInteger bannerType = [bannerModel.linkType integerValue];
    
    switch (bannerType) {
        case 1://H5
        {
            WJWebViewController *webVC = [[WJWebViewController alloc] init];
            [webVC loadWeb:bannerModel.linkUrl];
            webVC.titleStr = @"活动详情";
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 2://店铺
        {
            WJThirdShopViewController *thirdShopVC = [[WJThirdShopViewController alloc] init];
            thirdShopVC.shopId = bannerModel.linkUrl;
            [self.navigationController pushViewController:thirdShopVC animated:YES];

        }
            break;
        case 3://商品详情
        {
            WJProductDetailController * productDetailVC = [[WJProductDetailController alloc]init];
            productDetailVC.productId = bannerModel.linkUrl;
            [self.navigationController pushViewController:productDetailVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark- ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < - 64 ) {
        self.navigationController.navigationBar.hidden = YES;
        
    } else {
        
        self.navigationController.navigationBar.hidden = NO;
        CGFloat tempOffset = ALD(bannerHeight - 64*3);
        if (offsetY > tempOffset) {
            CGFloat temp = ALD(bannerHeight - 64*2 ) - offsetY ;
            color = WJColorWhite;
            alpha = MIN(1, 1 - temp / ALD(64));
            [scanButton setImage:[UIImage imageNamed:@"Home_saoyisao_dark"] forState:UIControlStateNormal];
            
        }
        
        if (offsetY == - 64) {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
            [scanButton setImage:[UIImage imageNamed:@"Home_saoyisao_white"] forState:UIControlStateNormal];
            
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
            [scanButton setImage:[UIImage imageNamed:@"Home_saoyisao_dark"] forState:UIControlStateNormal];
            
        }
    }
}

#pragma mark - getter&&setter
- (SDCycleScrollView *)cycleScrollView
{
    if (_cycleScrollView == nil) {
//        NSArray *imageNames = @[[UIImage imageNamed:@"new_x1_19201200_01"],[UIImage imageNamed:@"new_x1_19201200_02"],[UIImage imageNamed:@"new_x1_19201200_03"],[UIImage imageNamed:@"new_x1_19201200_04"]];
//        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.6) shouldInfiniteLoop:YES imageNamesGroup:imageNames];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.6) delegate:self placeholderImage:BitmapBannerImage];

        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _cycleScrollView;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[WJRefreshCollectionView alloc] initWithFrame:CGRectMake(0, -NavigationBarHight, kScreenWidth, kScreenHeight + kNavigationBarHeight + kStatusBarHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = WJColorWhite;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView refreshNow:NO refreshViewType:WJRefreshViewTypeHeader];
        
        //默认
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kDefaultIdentifier];
        
        //分类
        [_collectionView registerClass:[WJCategoryCollectionViewCell class] forCellWithReuseIdentifier:kCategoryIdentifier];
        
        //品牌
        [_collectionView registerClass:[WJHotBrandCollectionViewCell class] forCellWithReuseIdentifier:kBrandIdentifier];
        
        //推荐
        [_collectionView registerClass:[WJHomeRecommendCollectionViewCell class] forCellWithReuseIdentifier:kRecommendIdentifier];

        //更多
        [_collectionView registerClass:[WJHomeMoreCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMoreCollectionViewIdentifier];
        
        [_collectionView registerClass:[WJHomeSpaceCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSpaceCellIdentifier];
    }
    return _collectionView;
}


- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.tintColor = WJColorWhite;
        _searchBar.translucent = NO;
        _searchBar.placeholder = @"搜索";
//        UIImage* clearImg = [UIImage imageNamed:@"home_search"];
//        clearImg= [clearImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0,10) resizingMode:UIImageResizingModeStretch];
//        [_searchBar setSearchFieldBackgroundImage:clearImg forState:UIControlStateNormal];

        
    }
    return _searchBar;
}

-(APIHomeTopManager *)homeTopManager
{
    if (_homeTopManager == nil) {
        _homeTopManager = [[APIHomeTopManager alloc] init];
        _homeTopManager.delegate = self;
    }
    _homeTopManager.idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    _homeTopManager.udidString = [[NSUUID UUID] UUIDString];

    return _homeTopManager;
}

-(APIHomeBottomManager *)homeBottomManager
{
    if (_homeBottomManager == nil) {
        _homeBottomManager = [[APIHomeBottomManager alloc] init];
        _homeBottomManager.delegate = self;
    }
    return _homeBottomManager;
}

-(NSMutableArray *)bannerArray
{
    if (nil == _bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

-(NSMutableArray *)categoryArray
{
    if (nil == _categoryArray) {
        _categoryArray = [NSMutableArray array];
    }
    return _categoryArray;
}

-(NSMutableArray *)brandArray
{
    if (nil == _brandArray) {
        _brandArray = [NSMutableArray array];
    }
    return _brandArray;
}

-(NSMutableArray *)recommendArray
{
    if (nil == _recommendArray) {
        _recommendArray = [NSMutableArray array];
    }
    return _recommendArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
