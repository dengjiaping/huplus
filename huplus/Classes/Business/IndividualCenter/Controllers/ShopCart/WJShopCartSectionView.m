//
//  WJShopCartSectionView.m
//  HuPlus
//
//  Created by reborn on 17/2/8.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJShopCartSectionView.h"

@interface WJShopCartSectionView ()
{
    UIButton    *shopSelectButton;
    UILabel     *shopNameL;
    UIImageView *merchantIconView;
    UIImageView *rightArrowImageView;
}
@end

@implementation WJShopCartSectionView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initView];
    }
    
    return self;
}

-(void)initView
{
    self.frame = CGRectMake(0, 0, kScreenWidth, ALD(44));
    self.contentView.backgroundColor = WJColorWhite;
    self.userInteractionEnabled = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, self.width, self.height);
    backButton.userInteractionEnabled = YES;
    [backButton addTarget:self action:@selector(tapShopAction) forControlEvents:UIControlEventTouchUpInside];
    
    shopSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shopSelectButton.frame = CGRectMake(ALD(10), ALD(10),  ALD(25), ALD(25));
    [shopSelectButton addTarget:self action:@selector(shopSelectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [shopSelectButton setImage:[UIImage imageNamed:@"address_nor"] forState:UIControlStateNormal];
    
    
    UIImage *shopImage = [UIImage imageNamed:@"shopIcon"];
    merchantIconView = [[UIImageView alloc] initWithFrame:CGRectMake(shopSelectButton.right + ALD(5), (ALD(44) - shopImage.size.height)/2, shopImage.size.width, shopImage.size.height)];
    
    
    shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(merchantIconView.right + ALD(10), (ALD(44) - ALD(20))/2, ALD(150), ALD(20))];
    shopNameL.textColor = WJColorBlack;
    shopNameL.font = WJFont12;
    shopNameL.textAlignment = NSTextAlignmentLeft;
    
    
    rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(43), kScreenWidth, ALD(1))];
    lineView.backgroundColor = WJColorSeparatorLine;
    
    
    [self addSubview:backButton];
    [backButton addSubview:shopSelectButton];
    [backButton addSubview:merchantIconView];
    [backButton addSubview:shopNameL];
    [backButton addSubview:rightArrowImageView];
    [self addSubview:lineView];
}

-(void)configDataWithShopCartModel:(WJShopCartModel *)model
{
    shopNameL.text = model.shopName;
    
    CGSize txtSize = [shopNameL.text sizeWithAttributes:@{NSFontAttributeName:WJFont12} constrainedToSize:CGSizeMake(1000000, ALD(20))];
    
    UIImage *image = [UIImage imageNamed:@"icon_arrow_right"];
    rightArrowImageView.frame = CGRectMake(merchantIconView.right + ALD(20) + txtSize.width, (ALD(44) - image.size.height)/2, image.size.width, image.size.height);
    rightArrowImageView.image = image;
    merchantIconView.image = [UIImage imageNamed:@"shopIcon"];
    
    if (model.isSelect) {
        
        [shopSelectButton setImage:[UIImage imageNamed:@"shopCart_sel"] forState:UIControlStateNormal];
        
    } else {
        
        [shopSelectButton setImage:[UIImage imageNamed:@"shopCart_nor"] forState:UIControlStateNormal];
    }
}

-(void)tapShopAction
{
    self.tapShopBlock();
}

-(void)shopSelectButtonAction
{
    self.shopSelectBlock();
}

@end
