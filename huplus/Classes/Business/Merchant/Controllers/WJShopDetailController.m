//
//  WJShopDetailController.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/19.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJShopDetailController.h"
#import "WJHomeRecommendCollectionViewCell.h"
#import "WJCustomBannerView.h"
#import "WJShopDetailTopCell.h"

#import "WJProductListController.h"
#import "WJProductDetailController.h"

static NSString *const kBannweIdentifier = @"kBannweIdentifier";
static NSString *const kShopDetailIdentifier = @"kShopDetailIdentifier";
static NSString *const kGoodsIdentifier = @"kGoodsIdentifier";
static NSString *const kHeardViewIdentifier = @"kHeardViewIdentifier";
static NSString *const kFootViewIdentifier = @"kFootViewIdentifier";

@interface WJShopDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView           * mianCollectionView;
@property(nonatomic,strong)NSMutableArray             * dataArray;

@property(nonatomic,strong)WJCustomBannerView         * bannerView;
@property(nonatomic,strong)NSMutableArray             * bannerArray;

@end

@implementation WJShopDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺详情";
    self.isHiddenTabBar = YES;
    [self.view addSubview:self.mianCollectionView];
}

#pragma mark - Button Action
- (void)moreButtonAction
{
    NSLog(@"点击更多");
    WJProductListController *productListVC = [[WJProductListController alloc]init];
    [self.navigationController pushViewController:productListVC animated:YES];
}


#pragma mark - CollectionViewDelegate/CollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else {
        return 4;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    
    if (section == 0) {
        if (indexPath.row == 0) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannweIdentifier forIndexPath:indexPath];
            cell.backgroundColor = WJRandomColor;
//            __block typeof(self) blockSelf = self;
            self.bannerView = [WJCustomBannerView CreateBannerViewWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(224)) imageArray:self.bannerArray timerWithTimeInterval:1 imageClickBlock:^(NSInteger imageIndex) {
                NSLog(@"点击第%ld张轮播图",imageIndex);
            }];
            //可以修改属性
            _bannerView.pageControlAlignment=NSPageControlAlignmentCenter;
            [_bannerView startTimer];
    
            [cell addSubview:_bannerView];
            return cell;
        }else{
            WJShopDetailTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShopDetailIdentifier forIndexPath:indexPath];
            return cell;
        }
    } else {
        WJHomeRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGoodsIdentifier forIndexPath:indexPath];
        cell.backgroundColor = WJColorWhite;
        return cell;
    }
}


//header & footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeardViewIdentifier forIndexPath:indexPath];
            if (headerView == nil) {
                headerView = [[UICollectionViewCell alloc]init];
            }
            UILabel *label = [[UILabel alloc]initForAutoLayout];
            label.text = @"店铺橱窗";
            label.font = WJFont12;
            [headerView addSubview:label];
            [headerView addConstraints:[label constraintsLeftInContainer:10]];
            [headerView addConstraint:[label constraintCenterYInContainer]];
            headerView.backgroundColor = WJColorWhite;
            return headerView;
            
        }
        if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
            UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFootViewIdentifier forIndexPath:indexPath];
            if (footView == nil) {
                footView = [[UICollectionViewCell alloc]init];
            }
            UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
            [moreButton setTitleColor:WJColorDardGray6 forState:UIControlStateNormal];
            [moreButton.titleLabel setFont:WJFont13];
            moreButton.frame = CGRectMake(0, 0, footView.width, footView.height);
//            moreButton.titleLabel.font = WJFont13;
//            moreButton.titleLabel.textColor = WJColorDardGray6;
            [moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:moreButton];
            return footView;
        }
    }
    
    return nil;
}

//item尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    if (section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(kScreenWidth,ALD(224));
        }else{
            return CGSizeMake(kScreenWidth,ALD(160));
        }
    }else {
        return CGSizeMake((kScreenWidth - ALD(24))/2, ALD(200));
    }
}

//定义每个Section 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 20, 0);
    }else {
        return UIEdgeInsetsMake(12, 5, 12, 5);
    }
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//每个item之间的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 5.f;
//}

//返回头headerView的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, 0);
    }else{
        return CGSizeMake(kScreenWidth, 60);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, 0);
    }else{
        return CGSizeMake(kScreenWidth, 44);
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    if (section == 1) {
        NSLog(@"点击分类第%ld个cell",(long)indexPath.row);
        WJProductDetailController * productDetailVC = [[WJProductDetailController alloc]init];
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }
    
}

#pragma mark - setter and getter
- (UICollectionView *)mianCollectionView
{
    if (_mianCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsZero;
        _mianCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarAndStatBarHeight + kTabbarHeight) collectionViewLayout:layout];
        _mianCollectionView.backgroundColor = WJColorViewBg;
        
        _mianCollectionView.delegate = self;
        _mianCollectionView.dataSource = self;
        
        //banner
        [_mianCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kBannweIdentifier];
        
        //描述信息
        [_mianCollectionView registerClass:[WJShopDetailTopCell class] forCellWithReuseIdentifier:kShopDetailIdentifier];

        //商品橱窗
        [_mianCollectionView registerClass:[WJHomeRecommendCollectionViewCell class] forCellWithReuseIdentifier:kGoodsIdentifier];

        //注册header
        [_mianCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeardViewIdentifier];
        
        //注册foot
        [_mianCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFootViewIdentifier];
    }
    return _mianCollectionView;
}

-(NSMutableArray *)bannerArray
{
    if (nil == _bannerArray) {
        _bannerArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3", nil];
    }
    return _bannerArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
