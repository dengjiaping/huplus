//
//  WJThirdShopSectionCell.h
//  HuPlus
//
//  Created by reborn on 17/2/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJThirdShopSectionCell.h"
@class WJThirdShopSectionCell;
@protocol WJThirdShopSectionCellDelegate <NSObject>

-(void)shopSectionView:(WJThirdShopSectionCell *)cell clickIndex:(NSInteger)index;

@end

@interface WJThirdShopSectionCell : UICollectionViewCell
@property(nonatomic,weak)id<WJThirdShopSectionCellDelegate> delegate;

@end
