//
//  WJBottonBarView.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/30.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJBottonBarView.h"

@implementation WJBottonBarView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}

- (void)addUI
{
    UIView *topLine = [[UIView alloc]initForAutoLayout];
    topLine.backgroundColor = WJColorTabTopLine;
    [self addSubview:topLine];
    [self addConstraints:[topLine constraintsSize:CGSizeMake(kScreenWidth, 0.5)]];
    [self addConstraints:[topLine constraintsTopInContainer:0]];
    
    _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_collectButton setImage:[UIImage imageNamed:@"collection_noSelect"] forState:UIControlStateNormal];
    [_collectButton setImage:[UIImage imageNamed:@"collection_select"] forState:UIControlStateSelected];
    [self addSubview:_collectButton];
    [self addConstraints:[_collectButton constraintsSize:CGSizeMake(kScreenWidth/3, kTabbarHeight)]];
    [self addConstraints:[_collectButton constraintsLeftInContainer:0]];
    [self addConstraints:[_collectButton constraintsBottomInContainer:0]];
    
    UIView *leftLine = [[UIView alloc]initForAutoLayout];
    leftLine.backgroundColor = WJColorTabTopLine;
    [self addSubview:leftLine];
    [self addConstraints:[leftLine constraintsSize:CGSizeMake(0.5, kTabbarHeight)]];
    [self addConstraints:[leftLine constraintsTop:0 FromView:topLine]];
    [self addConstraints:[leftLine constraintsLeft:0 FromView:_collectButton]];
    
    _addShopCarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addShopCarButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_addShopCarButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    _addShopCarButton.titleLabel.font = WJFont16;
    [_addShopCarButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
    [self addSubview:_addShopCarButton];
    [self addConstraints:[_addShopCarButton constraintsSize:CGSizeMake(kScreenWidth/3, kTabbarHeight)]];
    [self addConstraints:[_addShopCarButton constraintsLeft:0 FromView:leftLine]];
    [self addConstraints:[_addShopCarButton constraintsBottomInContainer:0]];
    
//    UIView *rightLine = [[UIView alloc]initForAutoLayout];
//    rightLine.backgroundColor = WJColorTabTopLine;
//    [self addSubview:rightLine];
//    [self addConstraints:[rightLine constraintsSize:CGSizeMake(0.5, kTabbarHeight)]];
//    [self addConstraints:[rightLine constraintsTop:0 FromView:topLine]];
//    [self addConstraints:[rightLine constraintsLeft:0 FromView:addShopCarButton]];
    
    _buyNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyNowButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_buyNowButton setTitle:@"立即购买" forState:UIControlStateNormal];
    _buyNowButton.backgroundColor = WJColorMainRed;
    _buyNowButton.titleLabel.font = WJFont16;
    [_buyNowButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    [self addSubview:_buyNowButton];
    [self addConstraints:[_buyNowButton constraintsSize:CGSizeMake(kScreenWidth/3, kTabbarHeight)]];
    [self addConstraints:[_buyNowButton constraintsLeft:0 FromView:_addShopCarButton]];
    [self addConstraints:[_buyNowButton constraintsBottomInContainer:0]];

}


@end
