//
//  WJChooseGoodsPropertyController.m
//  HuPlus
//
//  Created by XT Xiong on 2017/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJChooseGoodsPropertyController.h"
#import "WJChooseGoodsTopView.h"
#import "WJChooseGoodsSizeCell.h"
#import "WJChooseGoodsColorCell.h"
#import "WJDigitalSelectorView.h"
#import "WJAttributeModel.h"
#import "APIAddShoppingCartManager.h"
#import "WJOrderConfirmController.h"
#import "APIGetSizeColorSkuidManager.h"
#import "WJAttributeDetailModel.h"
#import "WJChooseGoodsPropertyReformer.h"
#import "WJProductModel.h"
#import "WJConfirmOrderReformer.h"

@interface WJChooseGoodsPropertyController ()<UITableViewDataSource, UITableViewDelegate,APIManagerCallBackDelegate>
{
    WJDigitalSelectorView *digitalSelectorView;
    NSInteger currentCount;
    NSInteger stockCount;
    
    NSInteger sizeTag;          //区分尺寸、颜色请求
    NSInteger colorTag;
    
    BOOL      isFirstChoose;    //是否第一次选择
    BOOL      isFirstChooseSize;//第一次选择类型
    
}
@property(nonatomic,strong)APIAddShoppingCartManager   *addShoppingCartManager;
@property(nonatomic,strong)APIGetSizeColorSkuidManager *getSizeColorSkuidManager;

@property(nonatomic,strong)UITableView                 *mainTableView;
@property(nonatomic,strong)UIButton                    *sureButton;
@property(nonatomic,strong)UIView                      *backgroundView;
@property(nonatomic,strong)WJChooseGoodsTopView        *topView;
@property(nonatomic,strong)WJChooseGoodsSizeCell       *sizeCell;
@property(nonatomic,strong)WJChooseGoodsColorCell      *colorCell;

@property(nonatomic,strong)NSMutableArray              *sizeListArray;
@property(nonatomic,strong)NSMutableArray              *colorListArray;
@property(nonatomic,strong)NSString                    *sizeId;
@property(nonatomic,strong)NSString                    *colorId;
@property(nonatomic,strong)NSString                    *skuId;

@property(nonatomic,strong)WJAttributeDetailModel     *sizeAttributeModel; //购物车编辑
@property(nonatomic,strong)WJAttributeDetailModel     *colorAttributeModel;
@property(nonatomic,strong)NSString                   *cardIdString;


@end

@implementation WJChooseGoodsPropertyController

#pragma mark - Life Ciryle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isFromProductDetail) {
        self.isHiddenTabBar = YES;        
    }
    self.view.backgroundColor = COLOR(1, 1, 1, 0.5);
    
    isFirstChoose = YES;
    
    currentCount = 1;
    stockCount = [self.productDetailModel.stock integerValue];
    
    [self.view addSubview:self.sureButton];

    [self.view addSubview:self.backgroundView];
    [self.view addConstraints:[_backgroundView constraintsSize:CGSizeMake(kScreenWidth, 400)]];
    [self.view addConstraints:[_backgroundView constraintsBottom:0 FromView:self.sureButton]];
    [self.view addConstraints:[_backgroundView constraintsLeftInContainer:0]];

    [_backgroundView addSubview:self.mainTableView];
    [_backgroundView addConstraint:[_mainTableView constraintWidth:kScreenWidth]];
    [_backgroundView addConstraints:[_mainTableView constraintsTop:0 FromView:_topView]];
    [_backgroundView addConstraints:[_mainTableView constraintsBottomInContainer:0]];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIAddShoppingCartManager class]]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShoppingCartCountRefresh" object:nil];
       
    } else if ([manager isKindOfClass:[APIGetSizeColorSkuidManager class]]) {
        
        NSMutableArray *array  = [manager fetchDataWithReformer:[[WJChooseGoodsPropertyReformer alloc] init]];
        
        //如果是选择尺寸请求
        if (self.sizeId.length > 0) {
            
            if (self.colorListArray.count > 0) {
                [self.colorListArray removeAllObjects];
            }
            self.colorListArray = array;
            [(UIView*)[self.colorCell.contentView.subviews lastObject] removeFromSuperview];
            [self.colorCell addButtonNameList:self.colorListArray];
            for (UIButton *button in _colorCell.buttonList) {
                button.backgroundColor = WJColorWhite;
                [button addTarget:self action:@selector(colorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            //选择尺寸后 刷新颜色部分
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
            [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            

        }
        //如果是选择颜色请求

        if (self.colorId.length > 0) {
            
            if (self.sizeListArray.count > 0) {
                [self.sizeListArray removeAllObjects];
            }
            self.sizeListArray = array;
            [(UIView*)[self.sizeCell.contentView.subviews lastObject] removeFromSuperview];
            [_sizeCell addButtonNameList:self.sizeListArray];
            for (UIButton *button in _sizeCell.buttonList) {
                button.backgroundColor = WJColorWhite;
                [button addTarget:self action:@selector(sizeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            //选择颜色后 刷新尺寸部分
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }

    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
}


#pragma mark - Button Action
- (void)sureButtonAction
{
    if (self.sizeId.length == 0 || self.colorId.length == 0 || (self.sizeId.length == 0 && self.colorId.length == 0)) {
        
        [[TKAlertCenter defaultCenter]  postAlertWithMessage:@"请选择颜色尺寸分类"];

    } else if (currentCount > stockCount) {
        
        [[TKAlertCenter defaultCenter]  postAlertWithMessage:@"数量超出范围"];

    } else {
        
        if (self.toNextController == ToAddShoppingCart) {
            [MobClick event:@"gwc_chenggong"];
            
            [self.view removeFromSuperview];
            [self.addShoppingCartManager loadData];
            
        } else if (self.toNextController == ToConfirmOrderController) {
            [MobClick event:@"buy_chenggong"];

            
            [self.view removeFromSuperview];
            
            WJOrderConfirmController *orderConfirmVC = [[WJOrderConfirmController alloc] init];
            orderConfirmVC.orderConfirmFromController = FromPayRightNow;
            
            orderConfirmVC.payRightNowManager.shopId = self.productDetailModel.shopId;
            orderConfirmVC.payRightNowManager.skuId = self.skuId;
            orderConfirmVC.payRightNowManager.goodsCount = currentCount;
            
            [self.navigationController pushViewController:orderConfirmVC animated:YES];
            
        }  else {
            
            [self.view removeFromSuperview];
            
            WJProductModel *productModel = [[WJProductModel alloc] init];
            productModel.name = self.productDetailModel.productName;
            productModel.productId = self.productDetailModel.productId;
            productModel.count = currentCount;
            productModel.imageUrl = self.productDetailModel.productPic;
            productModel.salePrice = self.productDetailModel.price;
            productModel.skuId = self.skuId;
            productModel.attributeArray = [NSMutableArray arrayWithObjects:self.sizeAttributeModel, self.colorAttributeModel ,nil];
            
            self.sureButtonBlock(productModel);
        }
    }

}

-(void)backButtonAction
{
    [self.view removeFromSuperview];
    [super removeFromParentViewController];
}

- (void)sizeBtnAction:(UIButton *)button
{
    if (isFirstChoose == YES) {
        isFirstChooseSize = YES;
        isFirstChoose = NO;
    }
    for (UIButton *btn in _sizeCell.buttonList) {
        if (btn != button) {
            btn.selected = NO;
        }
        btn.backgroundColor = WJColorWhite;
    }
    button.selected = !button.selected;
    
    if (button.selected) {
        button.backgroundColor = WJColorMainRed;
        sizeTag =  button.tag;
        
        WJAttributeDetailModel *attributeDetailModel = _sizeListArray[button.tag - 1001];
        self.sizeId = attributeDetailModel.valueId;
        self.sizeAttributeModel = attributeDetailModel;

        if (isFirstChooseSize == YES){
            if (sizeTag != 0) {
                self.colorId = @"";
                [self.getSizeColorSkuidManager loadData];
            }
        } else {
            //刷新价格、库存
            for (WJAttributeDetailModel *detailModel in _sizeListArray)
            {
                if (detailModel.valueId == attributeDetailModel.valueId)
                {
                    [self refreshTopView:attributeDetailModel];
                    stockCount = [attributeDetailModel.stock integerValue];
                }
            }
        }
    } else {
        button.backgroundColor = WJColorWhite;
        sizeTag = 0;
        isFirstChooseSize = NO;
        if (colorTag == 0 && sizeTag == 0) {
            isFirstChoose = YES;
            [self refreshSizeAndColorCell];
        }
    }
    
}

-(void)colorBtnAction:(UIButton *)button
{
    if (isFirstChoose == YES) {
        isFirstChooseSize = NO;
        isFirstChoose = NO;
    }
    for (UIButton *btn in _colorCell.buttonList) {
        if (btn != button) {
            btn.selected = NO;
        }
        btn.backgroundColor = WJColorWhite;
    }
    button.selected = !button.selected;

    if (button.selected) {
        button.backgroundColor = WJColorMainRed;
        colorTag = button.tag;
        
        WJAttributeDetailModel *attributeDetailModel = _colorListArray[button.tag - 2001];
        self.colorId = attributeDetailModel.valueId;
        self.colorAttributeModel = attributeDetailModel;
        
        if (isFirstChooseSize == NO) {
            if (!(colorTag == 0)) {
                self.sizeId = @"";
                [self.getSizeColorSkuidManager loadData];
            }
        } else {
            //刷新价格、库存
            for (WJAttributeDetailModel *detailModel in _colorListArray) {
                if (detailModel.valueId == attributeDetailModel.valueId) {
                    [self refreshTopView:attributeDetailModel];
                    stockCount = [attributeDetailModel.stock integerValue];

                }
            }
        }

    } else {
        button.backgroundColor = WJColorWhite;
        colorTag = 0;
        isFirstChooseSize = YES;
        if (colorTag == 0 && sizeTag == 0) {
            isFirstChoose = YES;
            [self refreshSizeAndColorCell];
        }
    }
}

-(void)refreshSizeAndColorCell
{
    self.colorListArray = nil;
    [(UIView*)[self.colorCell.contentView.subviews lastObject] removeFromSuperview];
    [self.colorCell addButtonNameList:self.colorListArray];
    for (UIButton *button in _colorCell.buttonList) {
        button.backgroundColor = WJColorWhite;
        [button addTarget:self action:@selector(colorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.sizeListArray = nil;
    [(UIView*)[self.sizeCell.contentView.subviews lastObject] removeFromSuperview];
    [self.sizeCell addButtonNameList:self.sizeListArray];
    for (UIButton *button in _sizeCell.buttonList) {
        button.backgroundColor = WJColorWhite;
        [button addTarget:self action:@selector(sizeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath *indexPath3=[NSIndexPath indexPathForRow:3 inSection:0];
    [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath2,indexPath3,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)refreshTopView:(WJAttributeDetailModel *)attributeDetailModel
{
    WJProductDetailModel *productDetailModel = [[WJProductDetailModel alloc] init];
    productDetailModel.price = attributeDetailModel.price;
    productDetailModel.originalPrice = attributeDetailModel.originalPrice;
    productDetailModel.skuId = attributeDetailModel.skuId;
    productDetailModel.stock = attributeDetailModel.stock;
    productDetailModel.productName = self.productDetailModel.productName;
    productDetailModel.productPic = self.productDetailModel.productPic;
    self.skuId = attributeDetailModel.skuId;
    [_topView configChooseViewWithModel:productDetailModel];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 20;
    }else if(indexPath.row == 1){
        return self.sizeCell.height;
    }else if(indexPath.row == 2){
        return 20;
    }else if (indexPath.row == 3){
        return self.sizeCell.height;
    }else if (indexPath.row == 4){
        return 20;
    }else{
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        WJAttributeModel *attributeModel = self.productDetailModel.attributeListArray[indexPath.row];
        return [self creativeDefaultCellWithTitleString:attributeModel.attributeName];

    }else if (indexPath.row == 1){
        return self.sizeCell;
    }else if(indexPath.row == 2){
        WJAttributeModel *attributeModel = self.productDetailModel.attributeListArray[indexPath.row - 1];
        return [self creativeDefaultCellWithTitleString:attributeModel.attributeName];

    }else if (indexPath.row == 3){
        return self.colorCell;
    }else if (indexPath.row == 4){
        return [self creativeDefaultCellWithTitleString:@"数量"];
    }else{
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        digitalSelectorView = [[WJDigitalSelectorView alloc] initWithFrame:CGRectMake(15, 10, [WJDigitalSelectorView width], [WJDigitalSelectorView height])];
        [digitalSelectorView refeshDigitalSelectorViewWithCount:currentCount];
        
        __weak typeof(self) weakSelf = self;
        [digitalSelectorView setCountChangeBlock:^(BOOL isIncrease) {
            
            [weakSelf selectViewCountChanged:isIncrease];
            
        }];
        
        [cell.contentView addSubview:digitalSelectorView];
        return cell;
    }
}

- (UITableViewCell *)creativeDefaultCellWithTitleString:(NSString *)titleString
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = titleString;
    cell.textLabel.font = WJFont14;
    cell.textLabel.textColor = WJColorNavigationBar;
    return cell;
}

-(void)selectViewCountChanged:(BOOL)isIncrease
{
    if (isIncrease) {
        currentCount += 1;
    } else {
        if (currentCount > 1) {
            currentCount -= 1;
        } else {
            currentCount = 1;
        }
    }
    [digitalSelectorView refeshDigitalSelectorViewWithCount:currentCount];
}

#pragma mark - Setter And Getter
-(NSMutableArray *)sizeListArray
{
    if (_sizeListArray == nil) {
        
        for (WJAttributeModel *attributeModel in self.productDetailModel.attributeListArray) {
            if ([attributeModel.attributeName isEqualToString:@"尺码"]) {
                _sizeListArray = [NSMutableArray arrayWithArray:attributeModel.listArray];
            }
        }
        
    }
    return _sizeListArray;
}

-(NSMutableArray *)colorListArray
{
    if (_colorListArray == nil) {
        
        for (WJAttributeModel *attributeModel in self.productDetailModel.attributeListArray) {
            if ([attributeModel.attributeName isEqualToString:@"颜色"]) {
                _colorListArray = [NSMutableArray arrayWithArray:attributeModel.listArray];
            }
        }
        
    }
    return _colorListArray;
}

- (WJChooseGoodsSizeCell *)sizeCell
{
    if (_sizeCell == nil) {
        _sizeCell = [[WJChooseGoodsSizeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SizeCell"];
        _sizeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_sizeCell addButtonNameList:self.sizeListArray];

        
        for (UIButton *button in _sizeCell.buttonList) {
            [button addTarget:self action:@selector(sizeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _sizeCell;
}

- (WJChooseGoodsColorCell *)colorCell
{
    if (_colorCell == nil) {
        _colorCell = [[WJChooseGoodsColorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ColorCell"];
        _colorCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_colorCell addButtonNameList:self.colorListArray];

        for (UIButton *button in _colorCell.buttonList) {
            [button addTarget:self action:@selector(colorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    return _colorCell;
}


- (UITableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 152, kScreenWidth, _backgroundView.y - _topView.y) style:UITableViewStylePlain];
        _mainTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.bounces = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

- (UIView *)backgroundView
{
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc]initForAutoLayout];
        _backgroundView.backgroundColor = WJColorWhite;
        [_backgroundView addSubview:self.topView];
        [_backgroundView addConstraints:[_topView constraintsSize:CGSizeMake(kScreenWidth, 152)]];
        [_backgroundView addConstraints:[_topView constraintsTopInContainer:0]];
    }
    return _backgroundView;
}

- (UIButton *)sureButton
{
    if (_sureButton == nil) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(0, kScreenHeight - kNavBarAndStatBarHeight - kTabbarHeight, kScreenWidth, kTabbarHeight);
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = WJFont16;
        [_sureButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
        _sureButton.backgroundColor = WJColorMainRed;
        [_sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (WJChooseGoodsTopView *)topView
{
    if (_topView == nil) {
        _topView = [[WJChooseGoodsTopView alloc]initForAutoLayout];
        [_topView.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_topView configChooseViewWithModel:self.productDetailModel];
    }
    return _topView;
}

-(APIAddShoppingCartManager *)addShoppingCartManager
{
    if (_addShoppingCartManager == nil) {
        _addShoppingCartManager = [[APIAddShoppingCartManager alloc] init];
        _addShoppingCartManager.delegate = self;
    }
    
    _addShoppingCartManager.userId = USER_ID;
    _addShoppingCartManager.storeId = self.productDetailModel.shopId;
    _addShoppingCartManager.productId = self.productDetailModel.productId;
    _addShoppingCartManager.skuId = self.skuId;
    _addShoppingCartManager.productCount = currentCount;
    return _addShoppingCartManager;
}

-(APIGetSizeColorSkuidManager *)getSizeColorSkuidManager
{
    if (_getSizeColorSkuidManager == nil) {
        _getSizeColorSkuidManager = [[APIGetSizeColorSkuidManager alloc] init];
        _getSizeColorSkuidManager.delegate = self;
    }
    
    _getSizeColorSkuidManager.productId = self.productDetailModel.productId;
    _getSizeColorSkuidManager.sizeId = self.sizeId;
    _getSizeColorSkuidManager.colorId = self.colorId;
    return _getSizeColorSkuidManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
