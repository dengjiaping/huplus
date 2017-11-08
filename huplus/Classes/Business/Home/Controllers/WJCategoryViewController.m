//
//  WJCategoryViewController.m
//  HuPlus
//
//  Created by reborn on 17/1/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJCategoryViewController.h"
#import "WJCategoryView.h"
#import "APICategrayListManager.h"
#import "WJCategoryListReformer.h"
#import "WJCategoryListModel.h"
#import "WJProductListController.h"

@interface WJCategoryViewController ()<APIManagerCallBackDelegate>

@property(nonatomic,strong)WJCategoryView             * categoryView;
@property(nonatomic,strong)APICategrayListManager     * categrayListManager;
@property(nonatomic, strong)NSMutableArray            * categoryArray;

@end

@implementation WJCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    self.isHiddenTabBar = YES;

    [self.view addSubview:self.categoryView];
    
    [self requestLoad];

}


-(void)requestLoad
{
    [self showLoadingView];
    [self.categrayListManager loadData];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    self.categoryArray = [manager fetchDataWithReformer:[[WJCategoryListReformer alloc]init]];

    if (self.categoryArray.count > 0) {
        [self.categoryArray removeObjectAtIndex:0];
    }
    self.categoryView.dataArray = _categoryArray;
    [self.categoryView.mainTableView reloadData];
    
    WJCategoryListModel *rootCategoryModel = [self.categoryView.dataArray objectAtIndex:1];
    self.categoryView.collecDataArray = rootCategoryModel.childListArray;
    [self.categoryView.mainCollectionView reloadData];
    
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    
}


#pragma mark - Setter And Getter
- (WJCategoryView *)categoryView
{
    if (_categoryView == nil) {
        _categoryView = [[WJCategoryView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarAndStatBarHeight)];
        _categoryView.categoryFrom = CategoryFromAll;
        _categoryView.backgroundColor = WJColorDarkGray;
        __block typeof(self) blockSelf = self;
        _categoryView.categoryListSelectBlock = ^(WJCategoryListModel *categoryListModel){
            WJProductListController *productListVC = [[WJProductListController alloc] init];
            productListVC.homeCategoryListModel = categoryListModel;
            [blockSelf.navigationController pushViewController:productListVC animated:YES];
        };
    }
    return _categoryView;
}

- (APICategrayListManager *)categrayListManager
{
    if (_categrayListManager == nil) {
        _categrayListManager = [[APICategrayListManager alloc]init];
        _categrayListManager.delegate = self;
    }
    return _categrayListManager;
}


@end
