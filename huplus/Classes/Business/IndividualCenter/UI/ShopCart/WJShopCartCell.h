//
//  WJShopCartCell.h
//  HuPlus
//
//  Created by reborn on 17/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJProductModel.h"
@protocol WJShopCartCellDelegate <NSObject>

-(void)countChanged:(BOOL)isIncrease Section:(NSInteger)section Index:(NSInteger)index;

@end

@interface WJShopCartCell : UITableViewCell

@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSInteger section;
@property(nonatomic,assign)BOOL      isCanClick; //是否跳转商品选择页

@property(nonatomic,weak)id<WJShopCartCellDelegate>delegate;
@property(nonatomic,strong)WJActionBlock deleteBlock;
@property(nonatomic,strong)WJActionBlock selectBlock;
@property(nonatomic,strong)WJActionBlock finishBlock;
@property(nonatomic,strong)WJActionBlock editBlock;


-(void)updateWithProductModel:(WJProductModel *)productModel;
@end
