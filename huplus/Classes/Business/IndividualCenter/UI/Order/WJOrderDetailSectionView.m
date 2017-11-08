//
//  WJOrderDetailSectionView.m
//  HuPlus
//
//  Created by reborn on 17/2/9.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJOrderDetailSectionView.h"
#import "WJOrderStoreModel.h"
@interface WJOrderDetailSectionView ()
{
    UILabel     *shopNameL;
    UIImageView *merchantIconView;
    UIImageView *rightArrowImageView;
}
@end

@implementation WJOrderDetailSectionView

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
    
    
    UIImage *shopImage = [UIImage imageNamed:@"shopIcon"];
    merchantIconView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), (ALD(44) - shopImage.size.height)/2, shopImage.size.width, shopImage.size.height)];
    
    
    shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(merchantIconView.right + ALD(10), (ALD(44) - ALD(20))/2, ALD(150), ALD(20))];
    shopNameL.textColor = WJColorBlack;
    shopNameL.font = WJFont12;
    shopNameL.textAlignment = NSTextAlignmentLeft;
    
    
    rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(43), kScreenWidth, ALD(1))];
    lineView.backgroundColor = WJColorSeparatorLine;
    
    
    [self addSubview:backButton];
    [backButton addSubview:merchantIconView];
    [backButton addSubview:shopNameL];
    [backButton addSubview:rightArrowImageView];
    [self addSubview:lineView];
}

-(void)configDataWithDetailModel:(WJOrderStoreModel *)model
{
    shopNameL.text = model.shopName;
    
    CGSize txtSize = [shopNameL.text sizeWithAttributes:@{NSFontAttributeName:WJFont12} constrainedToSize:CGSizeMake(1000000, ALD(20))];
    
    UIImage *image = [UIImage imageNamed:@"icon_arrow_right"];
    rightArrowImageView.frame = CGRectMake(merchantIconView.right + ALD(20) + txtSize.width, (ALD(44) - image.size.height)/2, image.size.width, image.size.height);
    rightArrowImageView.image = image;
    merchantIconView.image = [UIImage imageNamed:@"shopIcon"];
    
}

-(void)tapShopAction
{
    self.tapShopBlock();
}

@end
