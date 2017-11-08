//
//  WJBrandCell.m
//  HuPlus
//
//  Created by XT Xiong on 2017/1/11.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJBrandCell.h"
#import "WJBrandDetailModel.h"
#import <UIImageView+WebCache.h>

@interface WJBrandCell()
{
    UIImageView     * brandIV;
    UILabel         * titleLabel;
    UILabel         * onSaleLabel;
    UILabel         * detailLabel;

}


@end

@implementation WJBrandCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self gradientLayerWithView:self.contentView];
        
        brandIV = [[UIImageView alloc]initForAutoLayout];
        brandIV.backgroundColor = WJColorWhite;
        brandIV.layer.cornerRadius = 3;
        brandIV.layer.masksToBounds = YES;
        brandIV.layer.borderColor = WJColorViewBg2.CGColor;
        brandIV.layer.borderWidth = 0.5f;
        [self.contentView addSubview:brandIV];
        [self.contentView addConstraints:[brandIV constraintsSize:CGSizeMake(90, 60)]];
        [self.contentView addConstraints:[brandIV constraintsTopInContainer:10 + kNavBarAndStatBarHeight]];
        [self.contentView addConstraints:[brandIV constraintsLeftInContainer:10]];
        
        titleLabel = [[UILabel alloc]initForAutoLayout];
        titleLabel.font = WJFont14;
        titleLabel.textColor = WJColorWhite;
        [self.contentView addSubview:titleLabel];
        [self.contentView addConstraints:[titleLabel constraintsTopInContainer:18 + kNavBarAndStatBarHeight]];
        [self.contentView addConstraints:[titleLabel constraintsLeft:10 FromView:brandIV]];
        
        onSaleLabel = [[UILabel alloc]initForAutoLayout];
        onSaleLabel.font = WJFont12;
        onSaleLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"#fcb0b1"];
        [self.contentView addSubview:onSaleLabel];
        [self.contentView addConstraints:[onSaleLabel constraintsTop:11 FromView:titleLabel]];
        [self.contentView addConstraints:[onSaleLabel constraintsLeft:10 FromView:brandIV]];
        
        detailLabel = [[UILabel alloc]initForAutoLayout];
        detailLabel.font = WJFont14;
        detailLabel.textColor = WJColorDardGray9;
        detailLabel.numberOfLines = 0;

        [self.contentView addSubview:detailLabel];
        [self.contentView addConstraints:[detailLabel constraintsSize:CGSizeMake(kScreenWidth - 20, 60)]];
        [self.contentView addConstraints:[detailLabel constraintsTop:20 FromView:brandIV]];
        [self.contentView addConstraints:[detailLabel constraintsLeftInContainer:10]];
        
    }
    return self;
}

-(void)configData:(WJBrandDetailModel *)brandDetailModel
{
    [brandIV sd_setImageWithURL:[NSURL URLWithString:brandDetailModel.brandLogo] placeholderImage:BitmapBrandImage];
    titleLabel.text = brandDetailModel.brandName;
    onSaleLabel.text = [NSString stringWithFormat:@"在售商品%@件",brandDetailModel.onSaleCount];
}

#pragma mark - Custom Function
- (void)gradientLayerWithView:(UIView *)view
{
    UIColor *color1 = [WJUtilityMethod colorWithHexColorString:@"#f11c61"];
    UIColor *color2 = [WJUtilityMethod colorWithHexColorString:@"#fb551b"];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0),@(1.0),nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(1, 1);
    
}


@end
