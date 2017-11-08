//
//  WJShopDetailTopCell.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJShopDetailTopCell.h"

@interface WJShopDetailTopCell()
{
    UILabel        * titleLabel;
    UILabel        * tipsLabel;
    UILabel        * businessHoursLabel;
    UIView         * topLine;
    UIView         * middleLine;
    UIImageView    * addressIV;
    UILabel        * addressLabel;
}

@end

@implementation WJShopDetailTopCell

- (void)configDataWithModel:(NSDictionary *)dic
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {

        self.contentView.backgroundColor = WJColorWhite;
        
        titleLabel = [[UILabel alloc]initForAutoLayout];
        titleLabel.font = WJFont16;
        titleLabel.textColor = WJColorNavigationBar;
        titleLabel.text = @"朝阳万达广场虎+服饰";
        [self.contentView addSubview:titleLabel];
        [self.contentView addConstraints:[titleLabel constraintsTopInContainer:ALD(15)]];
        [self.contentView addConstraints:[titleLabel constraintsLeftInContainer:ALD(12)]];
        
        tipsLabel = [[UILabel alloc]initForAutoLayout];
        tipsLabel.font = WJFont13;
        tipsLabel.text = @"线下门店同步销售";
        tipsLabel.textColor = WJColorLightGray;
        [self.contentView addSubview:tipsLabel];
        [self.contentView addConstraints:[tipsLabel constraintsLeftInContainer:ALD(12)]];
        [self.contentView addConstraints:[tipsLabel constraintsTop:ALD(15) FromView:titleLabel]];
        
        businessHoursLabel = [[UILabel alloc]initForAutoLayout];
        businessHoursLabel.font = WJFont13;
        businessHoursLabel.textColor = WJColorNavigationBar;
        businessHoursLabel.text = @"营业时间：9：00 - 23：00";
        [self.contentView addSubview:businessHoursLabel];
        [self.contentView addConstraints:[businessHoursLabel constraintsLeftInContainer:ALD(12)]];
        [self.contentView addConstraints:[businessHoursLabel constraintsTop:ALD(15) FromView:tipsLabel]];
        
        topLine = [[UIView alloc]initForAutoLayout];
        topLine.backgroundColor = WJColorLightGray;
        [self.contentView addSubview:topLine];
        [self.contentView addConstraints:[topLine constraintsSize:CGSizeMake(kScreenWidth, 0.5)]];
        [self.contentView addConstraints:[topLine constraintsTop:ALD(15) FromView:businessHoursLabel]];
        
        self.addressBGView = [[UIView alloc]initForAutoLayout];
//        _addressBGView.backgroundColor = WJColorViewBg;
        [self.contentView addSubview:_addressBGView];
        [self.contentView addConstraints:[_addressBGView constraintsSize:CGSizeMake(kScreenWidth - 50, ALD(44))]];
        [self.contentView addConstraints:[_addressBGView constraintsBottomInContainer:0]];
        [self.contentView addConstraints:[_addressBGView constraintsTop:0 FromView:topLine]];

        addressIV = [[UIImageView alloc] initForAutoLayout];
        addressIV.image = [UIImage imageNamed:@"Detail-Pages_address_icon"];
        [self.addressBGView addSubview:addressIV];
        [self.addressBGView addConstraint:[addressIV constraintCenterYInContainer]];
        [self.addressBGView addConstraints:[addressIV constraintsLeftInContainer:ALD(12)]];
        
        addressLabel = [[UILabel alloc]initForAutoLayout];
        addressLabel.font = WJFont13;
        addressLabel.text = @"北京市东城区安定门外大街185号京宝大厦 安定门外大街185号京宝大安定门外大街185号京宝大";
        [self.addressBGView addSubview:addressLabel];
        [self.addressBGView addConstraints:[addressLabel constraintsSize:CGSizeMake(kScreenWidth - 100, 15)]];
        [self.addressBGView addConstraint:[addressLabel constraintCenterYInContainer]];
        [self.addressBGView addConstraints:[addressLabel constraintsLeft:ALD(8) FromView:addressIV]];
        
        self.telephoneButton = [[UIButton alloc]initForAutoLayout];
        [_telephoneButton setImage:[UIImage imageNamed:@"Detail-Pages_call_icon"] forState:UIControlStateNormal];
        [self.contentView addSubview:_telephoneButton];
        [self.contentView addConstraint:[_telephoneButton constraintCenterYEqualToView:_addressBGView]];
        [self.contentView addConstraints:[_telephoneButton constraintsRightInContainer:ALD(12)]];
    
        middleLine = [[UIView alloc]initForAutoLayout];
        middleLine.backgroundColor = WJColorLightGray;
        [self.contentView addSubview:middleLine];
        [self.contentView addConstraints:[middleLine constraintsSize:CGSizeMake(0.5, 30)]];
        [self.contentView addConstraint:[middleLine constraintCenterYEqualToView:_addressBGView]];
        [self.contentView addConstraints:[middleLine constraintsRight:ALD(12) FromView:_telephoneButton]];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressBGAction)];
        [self.addressBGView  addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)addressBGAction
{
    NSLog(@"点击成功");
}

@end
