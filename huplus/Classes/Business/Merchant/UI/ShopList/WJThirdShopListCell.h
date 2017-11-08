//
//  WJThirdShopListCell.h
//  HuPlus
//
//  Created by reborn on 17/2/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJThirdShopListModel.h"

@interface WJThirdShopListCell : UITableViewCell

@property(nonatomic,strong)WJActionBlock skipStoreBlock;
-(void)configDataWithThirdShopListModel:(WJThirdShopListModel *)model;

@end
