//
//  WJActivityListCell.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJActivityListCell.h"

@interface WJActivityListCell(){
    UIImageView    * backgroundIV;
    UILabel        * titleLabel;
}

@end

@implementation WJActivityListCell

- (void)configDataWithModel:(WJActivityListModel *)model
{
//    self.cardIV.backgroundColor = [WJUtilityMethod colorWithHexColorString:model.cardColorValue];
//    [self.logoIV sd_setImageWithURL:[NSURL URLWithString:model.cardLogolUrl] placeholderImage:[UIImage imageNamed:@"home_ad_default"]];
//    self.titleLabel.text = model.cardName;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        backgroundIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
//        self.backgroundView = backgroundIV;
        self.contentView.backgroundColor = WJRandomColor;
        
        UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, ALD(170) - ALD(66), kScreenWidth, ALD(66))];
        maskView.backgroundColor = WJColorBlack;
        [self.contentView addSubview:maskView];
        [self gradientLayerWithView:maskView];
        
        titleLabel = [[UILabel alloc]initForAutoLayout];
        titleLabel.font = WJFont15;
        titleLabel.text = @"Hip clothing for men and man";
        titleLabel.textColor = WJColorWhite;
        [self.contentView addSubview:titleLabel];
        [self.contentView addConstraints:[titleLabel constraintsLeftInContainer:15]];
        [self.contentView addConstraints:[titleLabel constraintsBottomInContainer:13]];
    }
    return self;
}


- (void)gradientLayerWithView:(UIView *)view
{
    UIColor *color1 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)   alpha:0.3];
    UIColor *color2 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.15];
    UIColor *color3 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor,color3.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0), @(0.5),@(1.0),nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //色值组
    gradientLayer.colors = colors;
    //范围色阶
    gradientLayer.locations = locations;
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint   = CGPointMake(0, 0);
    //添加盖板
    view.layer.mask = gradientLayer;
}


@end
