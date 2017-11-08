//
//  WJOrderDetailSectionView.h
//  HuPlus
//
//  Created by reborn on 17/2/9.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJOrderStoreModel.h"
@interface WJOrderDetailSectionView : UITableViewHeaderFooterView
@property(nonatomic, strong)WJActionBlock tapShopBlock;
-(void)configDataWithDetailModel:(WJOrderStoreModel *)model;


@end
