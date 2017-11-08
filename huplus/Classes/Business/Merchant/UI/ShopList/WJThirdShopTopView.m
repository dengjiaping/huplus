//
//  WJThirdShopTopView.m
//  HuPlus
//
//  Created by reborn on 17/2/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJThirdShopTopView.h"
#import <UIImageView+WebCache.h>
#import "WJThirdShopDetailModel.h"
@interface WJThirdShopTopView ()
{
    UIImageView     * bgViewIV;
    UIImageView     * shopIV;
    UILabel         * shopNameL;
    UILabel         * onSaleLabel;
}

@end

@implementation WJThirdShopTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        bgViewIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(150))];
        bgViewIV.backgroundColor = [UIColor redColor];
        [self addSubview:bgViewIV];
        
        shopIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(10), ALD(20) + kNavBarAndStatBarHeight, ALD(60), ALD(60))];
        shopIV.image = [WJUtilityMethod createImageWithColor:WJColorCardRed];
        [bgViewIV addSubview:shopIV];
        
        shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(shopIV.right + ALD(10), ALD(28) + kNavBarAndStatBarHeight, kScreenWidth - ALD(75), ALD(30))];
        shopNameL.font = WJFont15;
        shopNameL.textColor = WJColorWhite;
        shopNameL.text = @"虎都男装官方旗舰店";
        [bgViewIV addSubview:shopNameL];
        
        onSaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(shopNameL.frame.origin.x, shopNameL.bottom, ALD(100), ALD(20))];
        onSaleLabel.font = WJFont12;
        onSaleLabel.textColor = WJColorWhite;
        onSaleLabel.text = @"在售商品1367件";
        [bgViewIV addSubview:onSaleLabel];

    }
    return self;
    
}

-(void)configDataWithThirdShopDetailModel:(WJThirdShopDetailModel *)model
{
    [bgViewIV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
    [shopIV sd_setImageWithURL:[NSURL URLWithString:model.shopIconUrl] placeholderImage:[UIImage imageNamed:@"bitmap_brand"]];
    shopNameL.text = model.shopName;
    onSaleLabel.text = [NSString stringWithFormat:@"在售商品%ld件",model.saleCount];
}


@end
