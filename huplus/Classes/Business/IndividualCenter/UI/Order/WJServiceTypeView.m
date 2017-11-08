//
//  WJServiceTypeView.m
//  HuPlus
//
//  Created by reborn on 16/12/29.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJServiceTypeView.h"
@interface WJServiceTypeView ()
{
    UILabel *titleL;
    UIButton *maintainButton;
    UIButton *returnedProductButton;
    UIButton *refundButton;
}
@end
@implementation WJServiceTypeView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(10), kScreenWidth, ALD(20))];
        titleL.text = @"服务类型";
        titleL.textColor = WJColorNavigationBar;
        titleL.font = WJFont13;
        
//        maintainButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        maintainButton.frame = CGRectMake(ALD(10), titleL.bottom + ALD(10), ALD(90), ALD(30));
//        [maintainButton setTitle:@"维修" forState:UIControlStateNormal];
//        [maintainButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
//        maintainButton.layer.cornerRadius = 4;
//        maintainButton.layer.borderColor = WJColorLightGray.CGColor;
//        maintainButton.layer.borderWidth = 0.5;
//        maintainButton.titleLabel.font = WJFont14;
//        [maintainButton addTarget:self action:@selector(maintainButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        returnedProductButton = [UIButton buttonWithType:UIButtonTypeCustom];
        returnedProductButton.frame = CGRectMake(ALD(10), titleL.bottom + ALD(10), ALD(90), ALD(30));

        if (self.serviceType == 0) {
            [returnedProductButton setTitle:@"仅退款" forState:UIControlStateNormal];

        } else {
            [returnedProductButton setTitle:@"退货/退款" forState:UIControlStateNormal];
        }
        [returnedProductButton setTitleColor:WJColorMainRed forState:UIControlStateNormal];
        returnedProductButton.layer.cornerRadius = 4;
        returnedProductButton.layer.borderColor = WJColorMainRed.CGColor;
        returnedProductButton.layer.borderWidth = 0.5;
        returnedProductButton.titleLabel.font = WJFont14;
//        [returnedProductButton addTarget:self action:@selector(returnedProductButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
//        refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        refundButton.frame = CGRectMake(returnedProductButton.right + ALD(10), returnedProductButton.frame.origin.y, ALD(90), ALD(30));
//        [refundButton setTitle:@"退款" forState:UIControlStateNormal];
//        [refundButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
//        refundButton.layer.cornerRadius = 4;
//        refundButton.layer.borderColor = WJColorLightGray.CGColor;
//        refundButton.layer.borderWidth = 0.5;
//        refundButton.titleLabel.font = WJFont14;
//        [refundButton addTarget:self action:@selector(refundButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:titleL];
//        [self addSubview:maintainButton];
        [self addSubview:returnedProductButton];
//        [self addSubview:refundButton];
        
    }
    return self;
}
#pragma mark - Action
//-(void)maintainButtonAction
//{
//    
//    [self changeAllButtonBorderColor];
//    maintainButton.layer.borderColor = WJColorNavigationBar.CGColor;
//
//}

//-(void)returnedProductButtonAction
//{
//    [self changeAllButtonBorderColor];
//
//    returnedProductButton.layer.borderColor = WJColorNavigationBar.CGColor;
//}

//-(void)refundButtonAction
//{
//    [self changeAllButtonBorderColor];
//
//    refundButton.layer.borderColor = WJColorNavigationBar.CGColor;
//
//}

//-(void)changeAllButtonBorderColor
//{
//    maintainButton.layer.borderColor = WJColorLightGray.CGColor;
//    returnedProductButton.layer.borderColor = WJColorLightGray.CGColor;
//    refundButton.layer.borderColor = WJColorLightGray.CGColor;
//}
@end
