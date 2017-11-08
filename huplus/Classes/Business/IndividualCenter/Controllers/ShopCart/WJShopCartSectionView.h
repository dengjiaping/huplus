//
//  WJShopCartSectionView.h
//  HuPlus
//
//  Created by reborn on 17/2/8.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJShopCartModel.h"
@interface WJShopCartSectionView : UITableViewHeaderFooterView
@property(nonatomic, strong)WJActionBlock shopSelectBlock;
@property(nonatomic, strong)WJActionBlock tapShopBlock;

-(void)configDataWithShopCartModel:(WJShopCartModel *)model;

@end
