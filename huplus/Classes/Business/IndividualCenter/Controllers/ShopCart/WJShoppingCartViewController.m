//
//  WJShoppingCartViewController.m
//  HuPlus
//
//  Created by reborn on 17/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJShoppingCartViewController.h"
#import "WJRefreshTableView.h"
#import "WJShopCartCell.h"
#import "WJProductModel.h"
#import "WJChooseGoodsPropertyController.h"
#import "WJOrderConfirmController.h"
#import "WJShopCartModel.h"
#import "WJShopCartSectionView.h"
#import "APIMyShopCartManager.h"
#import "WJMyShopCartReformer.h"
#import "WJProductDetailController.h"
#import "APIDeleteShopCartManager.h"
#import "APIEditShopCartManager.h"
#import "APIShopCartAttributeManager.h"
#import "WJProductDetailModel.h"
#import "WJProductDetailReformer.h"
#import "APIShopCartSettleManager.h"
#import "WJThirdShopViewController.h"
#import "WJEmptyView.h"
#import "WJThirdShopDetailViewController.h"

#define KShoppingCartCellIdentifier  @"KShoppingCartCellIdentifier"
@interface WJShoppingCartViewController ()<UITableViewDelegate, UITableViewDataSource,WJShopCartCellDelegate,APIManagerCallBackDelegate>
{
    BOOL      isHeaderRefresh;
    BOOL      isFooterRefresh;
    
    NSInteger deleteSection;
    NSInteger deleteIndex;
    
    NSInteger editSection;
    NSInteger editIndex;
    
    NSInteger totalCount;
    CGFloat   totalAmount;
    
    UILabel   *totalAmountL;
    UIButton  *settleButton;
    UILabel  *freightDesL;
    
    BOOL      isAllSelect;
    UIButton  *allSelectButton;
    
    UIView    *noDataView;
    
    UIView    *bgView;

}
@property(nonatomic,strong)WJRefreshTableView          *tableView;

@property(nonatomic,strong)APIMyShopCartManager        *myShopCartManager;
@property(nonatomic,strong)APIDeleteShopCartManager    *deleteShopCartManager;
@property(nonatomic,strong)APIEditShopCartManager      *editShopCartManager;
@property(nonatomic,strong)APIShopCartAttributeManager *shopCartAttributeManager;
@property(nonatomic,strong)APIShopCartSettleManager    *shopCartSettleManager;

@property(nonatomic,strong)WJProductModel              *deleteProductModel;
@property(nonatomic,strong)WJProductModel              *editProductModel;
@property(nonatomic,strong)WJProductModel              *finishEditProductModel;

@property(nonatomic,strong)NSMutableArray              *productListArray;
@property(nonatomic,strong)NSMutableArray              *dataArray;

@property(nonatomic,strong)NSMutableArray              *cartListArray; //结算cardId列表
@property(nonatomic,strong)NSString                    *cardIdString;

@end

@implementation WJShoppingCartViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的购物车";
    if (self.shopCartFromController == fromTab) {
        [self hiddenBackBarButtonItem];
        self.isHiddenTabBar = NO;

    } else {
        self.isHiddenTabBar = YES;
    }
    isAllSelect = NO;
    totalCount = 0;
    
    [self.view addSubview:self.tableView];
    [self initBottomView];
    
    [self showLoadingView];
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:kTabShopCartVCRefresh object:nil];
    
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WJEmptyView *emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(86), kScreenWidth, ALD(140))];
    emptyView.tipLabel.text = @"您的购物车中没有商品，赶紧去挑选吧";
    emptyView.imageView.image = [UIImage imageNamed:@"shopCart_nodata_image"];
    [noDataView addSubview:emptyView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)refreshList
{
    [self.tableView startHeadRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBottomView
{
    bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.hidden = NO;

    if (self.shopCartFromController == fromTab) {
        
        bgView.frame = CGRectMake(0, kScreenHeight - kNavBarAndStatBarHeight  - kTabbarHeight- ALD(50), kScreenWidth, ALD(50));
    } else {
        
        bgView.frame = CGRectMake(0, kScreenHeight - kNavBarAndStatBarHeight - ALD(50), kScreenWidth, ALD(50));
    }
    
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = WJColorSeparatorLine.CGColor;
    bgView.backgroundColor = WJColorTabBar;
    [self.view addSubview:bgView];

    
    allSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    allSelectButton.frame = CGRectMake(ALD(12), 0, ALD(80), ALD(49));
    [allSelectButton setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
    [allSelectButton setImage:[UIImage imageNamed:@"shopCart_nor"] forState:UIControlStateNormal];
    [allSelectButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, ALD(30))];
    [allSelectButton addTarget:self action:@selector(allSelectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    allSelectButton.titleLabel.font = WJFont15;
    [bgView addSubview:allSelectButton];

    settleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settleButton.frame = CGRectMake(kScreenWidth - ALD(130), 0, ALD(130), bgView.height);
    settleButton.backgroundColor = WJColorMainRed;
    [settleButton setTitle:[NSString stringWithFormat:@"去结算(%ld)",totalCount] forState:UIControlStateNormal];
    [settleButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    [settleButton addTarget:self action:@selector(settleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    settleButton.titleLabel.font = WJFont16;
    settleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:settleButton];
    
    
    totalAmountL = [[UILabel alloc] initWithFrame:CGRectZero];
    totalAmountL.textColor = WJColorMainRed;
    totalAmountL.font = WJFont15;
    [bgView addSubview:totalAmountL];
    
    
    freightDesL = [[UILabel alloc] initWithFrame:CGRectZero];
    freightDesL.text = @"不含运费";
    freightDesL.textColor = WJColorDardGray9;
    freightDesL.font = WJFont12;
    [bgView addSubview:freightDesL];
}

#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.myShopCartManager.shouldCleanData = YES;
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
            
        }
        [self requestData];
    }
    
}

- (void)startFootRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        self.myShopCartManager.shouldCleanData = NO;
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
    
    if (self.dataArray.count > 0) {
        self.tableView.tableFooterView = [UIView new];
        bgView.hidden = NO;
        
    } else {
        
        self.tableView.tableFooterView = noDataView;
        bgView.hidden = YES;
    }
}

#pragma mark - request
-(void)requestData
{
    self.myShopCartManager.shouldCleanData = YES;
    self.myShopCartManager.currentPage = 1;
    [self.myShopCartManager loadData];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    if ([manager isKindOfClass:[APIMyShopCartManager class]]) {
        
        NSMutableDictionary *dic = [manager fetchDataWithReformer:[[WJMyShopCartReformer alloc] init]];
        NSInteger totalPage = [dic[@"totalPage"] integerValue];

        if (self.dataArray.count == 0) {
            self.dataArray = dic[@"listArray"];
            
        } else {
            
            if (self.myShopCartManager.currentPage <totalPage) {
                [self.dataArray addObjectsFromArray: dic[@"listArray"]];
            }
        }
        
        [self caculateTotalAmount];
        [self refreshAllSelectStatus];
        
        [self endGetData:YES];
        [self refreshFooterStatus:manager.hadGotAllData];
    
        
    } else if ([manager isKindOfClass:[APIDeleteShopCartManager class]]) {
        
        [self refreshList];
        
        if (self.shopCartFromController == fromProductDetailControllert) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProductDetailCount" object:nil];
        }

    } else if ([manager isKindOfClass:[APIEditShopCartManager class]]) {
        
        
    } else if ([manager isKindOfClass:[APIShopCartAttributeManager class]]) {
        
        WJProductDetailModel  *productDetailModel = [manager fetchDataWithReformer:[[WJProductDetailReformer alloc] init]];
        
        WJChooseGoodsPropertyController *chooseGoodsVC = [[WJChooseGoodsPropertyController alloc]init];
        chooseGoodsVC.toNextController = ToEditShoppingCart;
        chooseGoodsVC.productDetailModel = productDetailModel;
        chooseGoodsVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self addChildViewController:chooseGoodsVC];
        [self.view addSubview:chooseGoodsVC.view];
    
        //编辑后刷新购物车
        chooseGoodsVC.sureButtonBlock = ^(WJProductModel *model) {
          
            WJShopCartModel *shopCartModel = self.dataArray[editSection];
            [shopCartModel.productListArray replaceObjectAtIndex:editIndex withObject:model];
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:editIndex inSection:editSection];
            
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
            model.cartId = self.editProductModel.cartId;
            self.finishEditProductModel = model;

        };
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    if ([manager isKindOfClass:[APIMyShopCartManager class]]) {
        
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
            
        }else{
            
            [self refreshFooterStatus:self.myShopCartManager.hadGotAllData];
            [self endGetData:NO];
            
        }
        
    }
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataArray == nil || self.dataArray.count == 0) {
        return 0;
    } else {
        return self.dataArray.count;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    WJShopCartModel *shopCartModel = self.dataArray[section];
    
    if (shopCartModel.productListArray == nil || shopCartModel.productListArray.count == 0) {
        return 0;
    } else {
        return shopCartModel.productListArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(140);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(44);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *viewIdentfier = @"headView";
    
    WJShopCartSectionView *sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
    
    if(!sectionHeadView){
        
        sectionHeadView = [[WJShopCartSectionView alloc] initWithReuseIdentifier:viewIdentfier];
    }
    
    [sectionHeadView configDataWithShopCartModel:self.dataArray[section]];
    
    __weak typeof(self) weakSelf = self;
                                        
    sectionHeadView.shopSelectBlock = ^{
        
        __strong typeof(self) strongSelf = weakSelf;
        
        WJShopCartModel *shopCartModel = self.dataArray[section];
        
        if (shopCartModel.isSelect) {
            
            shopCartModel.isSelect = NO;
            shopCartModel.selectedCount = 0;
            //单个店铺下商品全部未选中
            for (id object in shopCartModel.productListArray) {
                
                if ([object isKindOfClass:[WJProductModel class]]) {
                    
                    WJProductModel *model = (WJProductModel *)object;
                    model.isSelect = NO;
                }
                
            }
            
            
        } else {
            
            shopCartModel.isSelect = YES;
            shopCartModel.selectedCount = shopCartModel.productListArray.count;

            //单个店铺下商品全部选中
            for (id object in shopCartModel.productListArray) {
                
                if ([object isKindOfClass:[WJProductModel class]]) {
                    
                    WJProductModel *model = (WJProductModel *)object;
                    model.isSelect = YES;
                }
                
            }
            
        }
        
        [strongSelf refreshAllSelectStatus];
        [strongSelf caculateTotalAmount];
        [strongSelf.tableView reloadData];
        
    };
    
     sectionHeadView.tapShopBlock = ^{
        
         WJShopCartModel *shopCartModel = self.dataArray[section];
         
         WJThirdShopDetailViewController *thirdShopVC = [[WJThirdShopDetailViewController alloc] init];
         thirdShopVC.shopId = shopCartModel.shopId;
         [self.navigationController pushViewController:thirdShopVC animated:NO];
         
     };
    
    return sectionHeadView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:KShoppingCartCellIdentifier];
    cell.section = indexPath.section;
    cell.index = indexPath.row;
    
    if (!cell) {
        cell = [[WJShopCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KShoppingCartCellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorWhite;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
    }
    
    __weak typeof(self) weakSelf = self;
    
    cell.deleteBlock = ^ {
        __strong typeof(self) strongSelf = weakSelf;
        
        WJShopCartModel *shopCartModel = self.dataArray[indexPath.section];
        
        if (indexPath.row < shopCartModel.productListArray.count) {
            //删除
            deleteSection = indexPath.section;
            deleteIndex = indexPath.row;
            
            strongSelf.deleteProductModel =  [shopCartModel.productListArray objectAtIndex:deleteIndex];
            
            [strongSelf.deleteShopCartManager loadData];
        }
 
    };
    
    cell.selectBlock = ^ {
        
        __strong typeof(self) strongSelf = weakSelf;
        //选中
        [strongSelf selectSingleProduct:indexPath.section Index:indexPath.row];
        
    };
    
    cell.editBlock = ^ {
        
        //编辑
        editSection = indexPath.section;
        editIndex = indexPath.row;
    
    };
    
    cell.finishBlock = ^ {
        
        if (self.finishEditProductModel) {
            
            if (self.finishEditProductModel.count > self.finishEditProductModel.stock) {
                
                [[TKAlertCenter defaultCenter]  postAlertWithMessage:@"数量超出范围"];

            } else {
                
                [self.editShopCartManager loadData];
            }
            
        }
    };
    
    WJShopCartModel *shopCartModel = self.dataArray[indexPath.section];
    [cell updateWithProductModel:shopCartModel.productListArray[indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJShopCartCell *shopCartCell = (WJShopCartCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    
    if (shopCartCell.isCanClick) {
        
        //商品选择
        WJShopCartModel *shopCartModel = self.dataArray[indexPath.section];
        WJProductModel *productModel = shopCartModel.productListArray[indexPath.row];
        self.editProductModel = productModel;
        
        [self.shopCartAttributeManager loadData];
        
    } else {
        
        //商品详情
        WJShopCartModel *shopCartModel = self.dataArray[indexPath.section];
        WJProductModel *productModel = shopCartModel.productListArray[indexPath.row];
        
        WJProductDetailController *productDetailVC = [[WJProductDetailController alloc] init];
        productDetailVC.productId = productModel.productId;
        [self.navigationController pushViewController:productDetailVC animated:YES];
        
    }
}

-(void)selectSingleProduct:(NSInteger)section Index:(NSInteger)index
{
    WJShopCartModel *shopCartModel = self.dataArray[section];
    id object = shopCartModel.productListArray[index];
    
    //单个商品选中
    if ([object isKindOfClass:[WJProductModel class]]) {
        
        WJProductModel *tProductModel = (WJProductModel *)object;
        
        if (tProductModel.isSelect) {
            tProductModel.isSelect = NO;
            
            if (shopCartModel.selectedCount >= 1) {
                shopCartModel.selectedCount -= 1;
                
            } else {
                shopCartModel.selectedCount = 0;
            }
            
        } else {
            
            tProductModel.isSelect = YES;
            shopCartModel.selectedCount += 1;

        }
        
        //单个商品选中，对应店铺选中状态改变
        if (shopCartModel.selectedCount == shopCartModel.productListArray.count) {
            shopCartModel.isSelect = YES;

        } else {
            shopCartModel.isSelect = NO;
        }
        
    }

    [self refreshAllSelectStatus];
    [self caculateTotalAmount];
    
    //刷新section店铺
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //刷新店铺下商品
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:section];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

}

#pragma mark - Action
-(void)allSelectButtonAction
{
    if (isAllSelect) {
        
        isAllSelect = NO;
        [allSelectButton setImage:[UIImage imageNamed:@"shopCart_nor"] forState:UIControlStateNormal];
        
        for (WJShopCartModel *shopCartModel in self.dataArray) {
            
            shopCartModel.isSelect = NO;
            shopCartModel.selectedCount = 0;
            
            for (id object in shopCartModel.productListArray) {
                
                if ([object isKindOfClass:[WJProductModel class]]) {
                
                    WJProductModel *model = (WJProductModel *)object;
                    model.isSelect = NO;

                }
                
            }
        }
        
        [self caculateTotalAmount];
        [self.tableView reloadData];
        
    } else {
        
        isAllSelect = YES;
        [allSelectButton setImage:[UIImage imageNamed:@"shopCart_sel"] forState:UIControlStateNormal];

        
        for (WJShopCartModel *shopCartModel in self.dataArray) {
            
            shopCartModel.isSelect = YES;
            shopCartModel.selectedCount = shopCartModel.productListArray.count;

            for (id object in shopCartModel.productListArray) {
                
                if ([object isKindOfClass:[WJProductModel class]]) {
                    
                    WJProductModel *model = (WJProductModel *)object;
                    model.isSelect = YES;

                }
                
            }
        }
        
        [self caculateTotalAmount];
        [self.tableView reloadData];
        
    }
    
}

#pragma mark - Method
 //刷新底部金额
-(void)caculateTotalAmount
{
    totalAmount = 0;
    totalCount = 0;
    
    for (WJShopCartModel *shopCartModel in self.dataArray) {
        
        for (WJProductModel *model in shopCartModel.productListArray) {
            
            if (model.isSelect) {
                totalAmount += [model.salePrice floatValue] *model.count;
                totalCount += 1;
            }
        }
    }
    totalAmountL.text = [NSString stringWithFormat:@"合计：¥%.2f",totalAmount];
    [settleButton setTitle:[NSString stringWithFormat:@"去结算(%ld)",totalCount] forState:UIControlStateNormal];
    
    CGSize txtSize = [totalAmountL.text sizeWithAttributes:@{NSFontAttributeName:WJFont15} constrainedToSize:CGSizeMake(1000000, ALD(20))];

    totalAmountL.frame = CGRectMake(kScreenWidth - settleButton.width - ALD(15) - txtSize.width, ALD(10), txtSize.width, ALD(20));
    
    freightDesL.frame =  CGRectMake(totalAmountL.frame.origin.x, totalAmountL.bottom, txtSize.width, ALD(20));

}

//刷新底部全选状态
-(void)refreshAllSelectStatus
{
    NSInteger totalShopCount = 0;
    
    for (WJShopCartModel *shopCart in self.dataArray) {
        
        if (shopCart.isSelect) {
            totalShopCount += 1;
        }
    }
    
    if (totalShopCount == self.dataArray.count) {
        
        isAllSelect = YES;
        [allSelectButton setImage:[UIImage imageNamed:@"shopCart_sel"] forState:UIControlStateNormal];
    } else {
        isAllSelect = NO;
        [allSelectButton setImage:[UIImage imageNamed:@"shopCart_nor"] forState:UIControlStateNormal];
        
    }
}

#pragma mark - Action
-(void)settleButtonAction
{
    [MobClick event:@"guc_jiesuan"];
    
    for (id object in self.dataArray) {
        
        if ([object isKindOfClass:[WJShopCartModel class]]) {
            WJShopCartModel *shopCartModel = (WJShopCartModel *)object;
            
            for (id obj in shopCartModel.productListArray) {
                if ([obj isKindOfClass:[WJProductModel class]]) {
                    WJProductModel *productModel = (WJProductModel *)obj;
                    
                    if (productModel.isSelect) {
                        
                        [self.cartListArray addObject:productModel.cartId];
                        self.cardIdString = [self.cartListArray componentsJoinedByString:@","];
    
                    }
                }
                
            }
        }
        
    }
    
    if (self.cartListArray.count > 0) {
    
        [WJGlobalVariable sharedInstance].payfromController = self;

        WJOrderConfirmController *orderConfirmVC = [[WJOrderConfirmController alloc] init];
        orderConfirmVC.cardIdString = self.cardIdString;
        orderConfirmVC.orderConfirmFromController = FromShopCart;
        [self.navigationController pushViewController:orderConfirmVC animated:YES];
        [self.cartListArray removeAllObjects];
    }
    
}

- (void)backBarButton:(UIButton *)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - WJShopCartCellDelegate
-(void)countChanged:(BOOL)isIncrease Section:(NSInteger)section Index:(NSInteger)index
{
    WJShopCartModel *shopCartModel = self.dataArray[section];
    WJProductModel *productModel = shopCartModel.productListArray[index];
    
    if (isIncrease) {
        productModel.count += 1;
    } else {
        
        
        if (productModel.count > 1) {
            productModel.count -= 1;
        } else {
            
            productModel.count = 1;
        }
        
//        if (productModel.count == 1) {
//            
//            [shopCartModel.productListArray removeObject:productModel];
//            [self.dataArray removeObjectAtIndex:section];
//        }
//        productModel.count -= 1;
    }
    
    self.finishEditProductModel = productModel;

    [self.tableView reloadData];
}

#pragma mark - setter/getter
-(WJRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight  - kNavigationBarHeight) style:UITableViewStyleGrouped refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 0.01f)];
        
    }
    return _tableView;
}

-(NSMutableArray *)productListArray
{
    if (!_productListArray) {
        _productListArray = [NSMutableArray array];
    }
    return _productListArray;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)cartListArray
{
    if (!_cartListArray) {
        _cartListArray = [NSMutableArray array];
    }
    return _cartListArray;
}

-(APIMyShopCartManager *)myShopCartManager
{
    if (_myShopCartManager == nil) {
        _myShopCartManager = [[APIMyShopCartManager alloc] init];
        _myShopCartManager.delegate = self;
    }
    _myShopCartManager.userId = USER_ID;
    _myShopCartManager.shouldParse = YES;
    return _myShopCartManager;
}

-(APIDeleteShopCartManager *)deleteShopCartManager
{
    if (_deleteShopCartManager == nil) {
        _deleteShopCartManager = [[APIDeleteShopCartManager alloc] init];
        _deleteShopCartManager.delegate = self;
    }
    
    _deleteShopCartManager.userId = USER_ID;
    _deleteShopCartManager.cartId = _deleteProductModel.cartId;
    return _deleteShopCartManager;
}

-(APIEditShopCartManager *)editShopCartManager
{
    if (_editShopCartManager == nil) {
        _editShopCartManager = [[APIEditShopCartManager alloc] init];
        _editShopCartManager.delegate = self;
    }
    
    _editShopCartManager.userId = USER_ID;
    _editShopCartManager.productId = self.finishEditProductModel.productId;
    _editShopCartManager.skuId = self.finishEditProductModel.skuId;
    _editShopCartManager.cartId = self.finishEditProductModel.cartId;
    _editShopCartManager.count = self.finishEditProductModel.count;
    
    return _editShopCartManager;
}

-(APIShopCartAttributeManager *)shopCartAttributeManager
{
    if (_shopCartAttributeManager == nil) {
        _shopCartAttributeManager = [[APIShopCartAttributeManager alloc] init];
        _shopCartAttributeManager.delegate = self;
    }
    _shopCartAttributeManager.productId = self.editProductModel.productId;
    _shopCartAttributeManager.skuId = self.editProductModel.skuId;
    return _shopCartAttributeManager;
}
@end
