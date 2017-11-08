//
//  WJHomeRecommendCollectionViewCell.m
//  HuPlus
//
//  Created by reborn on 16/12/19.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJHomeRecommendCollectionViewCell.h"
#import <UIImageView+WebCache.h>
@interface WJHomeRecommendCollectionViewCell ()
{
    UIImageView *imageView;
    UILabel     *nameL;
    UILabel     *titleL;
    UILabel     *priceL;
}

@end

@implementation WJHomeRecommendCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WJColorWhite;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        imageView.backgroundColor = [UIColor clearColor];
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + ALD(5), imageView.width, ALD(20))];
        nameL.font = WJFont12;
        nameL.textAlignment = NSTextAlignmentCenter;
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, nameL.bottom, frame.size.width,ALD(20))];
        titleL.font = WJFont12;
        titleL.textAlignment = NSTextAlignmentCenter;
        
        priceL = [[UILabel alloc] initWithFrame:CGRectMake(0, titleL.bottom,frame.size.width , ALD(20))];
        priceL.textColor = WJColorNavigationBar;
        priceL.textAlignment = NSTextAlignmentCenter;
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.frame = CGRectMake(imageView.width - ALD(20), 0, ALD(20), ALD(20));
        self.deleteButton.hidden = YES;
        [self.deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteButton setImage:[UIImage imageNamed:@"collection_delete"] forState:UIControlStateNormal];
        [self addSubview:imageView];
        [self addSubview:nameL];
        [self addSubview:titleL];
        [self addSubview:priceL];
        [imageView addSubview:self.deleteButton];
        
    }
    return self;
}

-(void)configDataWithModel:(WJHomeGoodsModel *)model
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.imgURL] placeholderImage:[UIImage imageNamed:@"bitmap_commodity"]];
    nameL.text = model.brandName;
    titleL.text = model.name;
    priceL.text = [NSString stringWithFormat:@"￥ %@", [WJUtilityMethod floatNumberForMoneyFomatter:[model.price floatValue]]];
}

-(void)configDataWithModel:(WJHomeGoodsModel *)model isShowDelete:(BOOL)isShowDelete
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.imgURL] placeholderImage:[UIImage imageNamed:@"bitmap_commodity"]];
    nameL.text = model.brandName;
    titleL.text = model.name;
    priceL.text = [NSString stringWithFormat:@"￥ %@", [WJUtilityMethod floatNumberForMoneyFomatter:[model.price floatValue]]];
    
    if (isShowDelete) {
        self.deleteButton.hidden = NO;
    } else {
        self.deleteButton.hidden = YES;
    }
}

-(void)deleteAction
{
    self.deleteBlock();
}

@end
