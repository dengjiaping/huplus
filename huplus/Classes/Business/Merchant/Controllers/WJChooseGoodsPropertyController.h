//
//  WJChooseGoodsPropertyController.h
//  HuPlus
//
//  Created by XT Xiong on 2017/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"
#import "WJProductDetailModel.h"
#import "WJProductModel.h"

typedef void(^SureButtonBlock)(WJProductModel *model);

typedef NS_ENUM(NSInteger, ChooseGoodsPropertyToController){
    
    ToAddShoppingCart = 0,        //添加到购物车
    ToConfirmOrderController = 1, //确认订单
    ToEditShoppingCart = 2,      //编辑购物车

};

@interface WJChooseGoodsPropertyController : WJViewController

@property(nonatomic,strong)WJProductDetailModel *productDetailModel;
@property(nonatomic,assign)ChooseGoodsPropertyToController toNextController;
@property(nonatomic,strong)SureButtonBlock sureButtonBlock;

@property(nonatomic,assign)BOOL         isFromProductDetail;

@end
