//
//  WJVipCardView.m
//  HuPlus
//
//  Created by reborn on 16/12/22.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJVipCardView.h"

@interface WJVipCardView ()
{
    UILabel *logolL;
    UILabel *vipCardNameL;
    UILabel *balanceL;
    UILabel *balanceTitleL;
    
    UIButton *chargeRecordButton;
    UIButton *consumeRecordButton;
    UIButton *chargeButton;
}

@end

@implementation WJVipCardView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WJColorWhite;
        self.layer.cornerRadius = 10;

        logolL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(20), ALD(20), ALD(100), ALD(30))];
//        logolL.backgroundColor = WJRandomColor;
        logolL.text = @"LOGO";
        
        
        vipCardNameL = [[UILabel alloc] initWithFrame:CGRectMake(logolL.frame.origin.x, logolL.bottom, ALD(100), ALD(30))];
//        vipCardNameL.backgroundColor = WJRandomColor;
        vipCardNameL.font = WJFont12;
        vipCardNameL.textColor = WJColorLightGray;
        vipCardNameL.text = @"虎+贵宾卡";
        
        balanceL = [[UILabel alloc] initWithFrame:CGRectMake(0, vipCardNameL.bottom + ALD(30), frame.size.width, ALD(50))];
        balanceL.textColor = WJColorNavigationBar;
        balanceL.text = @"28800.00";
        balanceL.textAlignment = NSTextAlignmentCenter;
        balanceL.font = WJFont24;
//        balanceL.backgroundColor = WJRandomColor;
        
        balanceTitleL = [[UILabel alloc] initWithFrame:CGRectMake((self.width - ALD(100))/2, balanceL.bottom, ALD(100), ALD(20))];
        balanceTitleL.textColor = WJColorLightGray;
        balanceTitleL.text = @"当前余额（元）";
        balanceTitleL.font = WJFont15;
        balanceTitleL.textAlignment = NSTextAlignmentCenter;
//        balanceTitleL.backgroundColor = WJRandomColor;
        
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, balanceTitleL.bottom + ALD(20), self.width, 0.5)];
        topLineView.backgroundColor = WJColorSeparatorLine;
        
        
        chargeRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chargeRecordButton.frame = CGRectMake(0, topLineView.bottom, frame.size.width, ALD(40));
        [chargeRecordButton setTitle:@"充值记录" forState:UIControlStateNormal];
        [chargeRecordButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        chargeRecordButton.titleLabel.font = WJFont14;
        [chargeRecordButton addTarget:self action:@selector(chargeRecordButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *midLineView = [[UIView alloc] initWithFrame:CGRectMake(0, chargeRecordButton.bottom, frame.size.width, 0.5)];
        midLineView.backgroundColor = WJColorSeparatorLine;
        
        consumeRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        consumeRecordButton.frame = CGRectMake(0, midLineView.bottom, frame.size.width, ALD(40));
        [consumeRecordButton setTitle:@"消费记录" forState:UIControlStateNormal];
        [consumeRecordButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        consumeRecordButton.titleLabel.font = WJFont14;
        [consumeRecordButton addTarget:self action:@selector(consumeRecordButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, consumeRecordButton.bottom, frame.size.width, 0.5)];
        bottomLineView.backgroundColor = WJColorSeparatorLine;
        
        
        chargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chargeButton.frame = CGRectMake((frame.size.width - ALD(250))/2, bottomLineView.bottom + ALD(50), ALD(250), ALD(30));
        [chargeButton setTitle:@"立即充值" forState:UIControlStateNormal];
        [chargeButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
        chargeButton.backgroundColor = WJColorMainRed;
        chargeButton.layer.cornerRadius = 15;
        chargeButton.titleLabel.font = WJFont14;
        [chargeButton addTarget:self action:@selector(chargeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:logolL];
        [self addSubview:vipCardNameL];
        [self addSubview:balanceL];
        [self addSubview:balanceTitleL];
        [self addSubview:topLineView];
        [self addSubview:chargeRecordButton];
        [self addSubview:midLineView];
        [self addSubview:consumeRecordButton];
        [self addSubview:bottomLineView];
        [self addSubview:chargeButton];
    }
    return self;
}

#pragma mark - Action
-(void)chargeRecordButtonAction
{
    if ([self.delegate respondsToSelector:@selector(vipCardViewClickChargeRecord)]) {
        [self.delegate vipCardViewClickChargeRecord];
    }
}

-(void)consumeRecordButtonAction
{
    if ([self.delegate respondsToSelector:@selector(vipCardViewClickConsumeRecord)]) {
        [self.delegate vipCardViewClickConsumeRecord];
    }
}

-(void)chargeButtonAction
{
    if ([self.delegate respondsToSelector:@selector(vipCardViewClickCharge)]) {
        [self.delegate vipCardViewClickCharge];
    }
}
@end
