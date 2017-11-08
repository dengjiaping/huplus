//
//  WJShopListCell.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/18.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJShopListCell.h"

@interface WJShopListCell(){
    UIImageView    * backgroundIV;
    UILabel        * titleLabel;
    UILabel        * distanceLabel;
    UILabel        * addressLabel;
}

@end

@implementation WJShopListCell

- (void)configDataWithModel:(WJShopListModel *)model
{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        backgroundIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
//        self.backgroundView = backgroundIV;
        self.contentView.backgroundColor = WJRandomColor;
        
        UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, ALD(170) - ALD(71), kScreenWidth, ALD(71))];
        maskView.backgroundColor = WJColorBlack;
        [self.contentView addSubview:maskView];
        [self gradientLayerWithView:maskView];
        
        addressLabel = [[UILabel alloc]initForAutoLayout];
        addressLabel.font = WJFont12;
        addressLabel.text = @"地址：北京市西城区大木仓胡同33号地址：北京市西城区大木仓地址：北京市西城区大木仓";
        addressLabel.textAlignment = NSTextAlignmentLeft;
        addressLabel.textColor = WJColorWhite;
        [self.contentView addSubview:addressLabel];
        [self.contentView addConstraint:[addressLabel constraintWidth:kScreenWidth - 90]];
        [self.contentView addConstraints:[addressLabel constraintsLeftInContainer:15]];
        [self.contentView addConstraints:[addressLabel constraintsBottomInContainer:9]];
        
        distanceLabel = [[UILabel alloc]initForAutoLayout];
        distanceLabel.font = WJFont12;
        distanceLabel.text = @"1200km";
        distanceLabel.textColor = WJColorWhite;
        [self.contentView addSubview:distanceLabel];
        [self.contentView addConstraints:[distanceLabel constraintsRightInContainer:15]];
        [self.contentView addConstraints:[distanceLabel constraintsBottomInContainer:9]];
        
        titleLabel = [[UILabel alloc]initForAutoLayout];
        titleLabel.font = WJFont15;
        titleLabel.text = @"万达广场";
        titleLabel.textColor = WJColorWhite;
        [self.contentView addSubview:titleLabel];
        [self.contentView addConstraints:[titleLabel constraintsLeftInContainer:15]];
        [self.contentView addConstraints:[titleLabel constraintsBottom:6 FromView:addressLabel]];
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
