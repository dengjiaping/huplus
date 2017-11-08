//
//  WJCreditsHeaderView.m
//  HuPlus
//
//  Created by reborn on 16/12/22.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJCreditsHeaderView.h"

@interface WJCreditsHeaderView ()
{
    UILabel *creditsL;
    UILabel *creditsDesL;
    UIButton *creditsExchangeButton;
}

@end

@implementation WJCreditsHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor = WJColorNavigationBar;
        
        [self gradientLayerWithView:self];
        
        
        creditsL = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(40), frame.size.width, ALD(40))];
        creditsL.text = @"7480";
        creditsL.textColor = WJColorWhite;
        creditsL.font = WJFont20;
        creditsL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:creditsL];
        
        creditsDesL = [[UILabel alloc] initWithFrame:CGRectMake(0, creditsL.bottom, frame.size.width, ALD(20))];
        creditsDesL.text = @"当前积分";
        creditsDesL.textColor = WJColorWhite;
        creditsDesL.font = WJFont12;
        creditsDesL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:creditsDesL];
        
        
        creditsExchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        creditsExchangeButton.frame = CGRectMake((frame.size.width - ALD(160))/2, creditsDesL.bottom + ALD(20), ALD(160), ALD(30));
        [creditsExchangeButton setTitle:@"立即兑换" forState:UIControlStateNormal];
        [creditsExchangeButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
        creditsExchangeButton.layer.cornerRadius = 15;
        creditsExchangeButton.layer.borderColor = WJColorWhite.CGColor;
        creditsExchangeButton.layer.borderWidth = 0.5f;
        creditsExchangeButton.titleLabel.font = WJFont14;
        [creditsExchangeButton addTarget:self action:@selector(creditsExchangeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:creditsExchangeButton];
        
    }
    return self;
}

- (void)refreshCreditsHeaderView:(NSString *)credits
{
    creditsL.text = credits;
}

#pragma mark - Action
- (void)creditsExchangeButtonAction
{
    if ([self.delegate respondsToSelector:@selector(creditsExchangeButtonClick)]) {
        [self.delegate creditsExchangeButtonClick];
    }
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
