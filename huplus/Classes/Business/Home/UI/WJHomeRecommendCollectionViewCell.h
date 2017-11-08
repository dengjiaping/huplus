//
//  WJHomeRecommendCollectionViewCell.h
//  HuPlus
//
//  Created by reborn on 16/12/19.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJHomeGoodsModel.h"

@interface WJHomeRecommendCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)WJActionBlock deleteBlock;
@property(nonatomic,strong)UIButton    *deleteButton;
-(void)configDataWithModel:(WJHomeGoodsModel *)model;
-(void)configDataWithModel:(WJHomeGoodsModel *)model isShowDelete:(BOOL)isShowDelete;

@end
