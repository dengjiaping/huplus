//
//  WJThirdShopListCell.m
//  HuPlus
//
//  Created by reborn on 17/2/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJThirdShopListCell.h"
#import "WJThirdShopListModel.h"
#import <UIImageView+WebCache.h>
#import "WJImageViewWithBK.h"
@interface WJThirdShopListCell ()
{
    WJImageViewWithBK *imageView;
    UIImageView *shopIconView;
    
    UILabel     *shopNameL;
    UILabel     *saleCountL;
    
    UIButton    *skipStoreButton;
}

@end


@implementation WJThirdShopListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(202))];
        backView.backgroundColor = WJColorViewBg2;
        [self addSubview:backView];
        
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(10), kScreenWidth - ALD(24), ALD(192))];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = ALD(3);
        bgView.layer.borderWidth = 1;
        bgView.layer.borderColor = WJColorSeparatorLine.CGColor;
        bgView.backgroundColor = WJColorWhite;
        [backView addSubview:bgView];
        
        imageView = [[WJImageViewWithBK alloc] initWithFrame:CGRectMake(0,0, bgView.width, ALD(132))];
        [bgView addSubview:imageView];
        
        shopIconView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(10), imageView.bottom + ALD(10), ALD(40), ALD(40))];
        shopIconView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:shopIconView];
        
        shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(shopIconView.right + ALD(10), imageView.bottom + ALD(10), bgView.width - ALD(70), ALD(20))];
        shopNameL.textColor = WJColorNavigationBar;
        shopNameL.font = WJFont15;
        [bgView addSubview:shopNameL];
        
        
        saleCountL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(shopNameL.frame), shopNameL.bottom + ALD(5), ALD(100), ALD(20))];
        saleCountL.textColor = WJColorDardGray9;
        saleCountL.font = WJFont12;
        [bgView addSubview:saleCountL];
        
        
        skipStoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        skipStoreButton.frame = CGRectMake(bgView.width - ALD(12) - ALD(80), shopNameL.origin.y + 4, ALD(80), ALD(30));
        [skipStoreButton setTitle:@"进店看看" forState:UIControlStateNormal];
        [skipStoreButton setTitleColor:WJColorMainRed forState:UIControlStateNormal];
        skipStoreButton.layer.cornerRadius = 15;
        skipStoreButton.layer.borderColor = WJColorMainRed.CGColor;
        skipStoreButton.layer.borderWidth = 0.5;
        skipStoreButton.titleLabel.font = WJFont14;
        [skipStoreButton addTarget:self action:@selector(skipStoreButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:skipStoreButton];

    }
    return self;
}

-(void)skipStoreButtonAction
{
    self.skipStoreBlock();
}


-(void)configDataWithThirdShopListModel:(WJThirdShopListModel *)model
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
    [shopIconView sd_setImageWithURL:[NSURL URLWithString:model.shopIconUrl] placeholderImage:[UIImage imageNamed:@"bitmap_brand"]];
    shopNameL.text = model.shopName;
    saleCountL.text = [NSString stringWithFormat:@"在售商品%ld件",model.saleCount];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
