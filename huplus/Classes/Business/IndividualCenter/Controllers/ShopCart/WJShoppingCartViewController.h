//
//  WJShoppingCartViewController.h
//  HuPlus
//
//  Created by reborn on 17/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"

typedef NS_ENUM(NSInteger, ShopCartFromController){
    
    fromProductDetailControllert = 0, // 商品详情
    fromTab = 1,                     //tab
};

@interface WJShoppingCartViewController : WJViewController
@property(nonatomic,assign)ShopCartFromController shopCartFromController;
@end
