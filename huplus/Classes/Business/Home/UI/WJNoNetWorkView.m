//
//  WJNoNetWorkView.m
//  HuPlus
//
//  Created by reborn on 17/4/20.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJNoNetWorkView.h"

@interface WJNoNetWorkView ()
{
    UIImageView *noNetWorkImageView;
}

@end


@implementation WJNoNetWorkView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WJColorViewBg;
        UIImage *noNetWorkImg = [UIImage imageNamed:@"no_netWork_icon"];
        noNetWorkImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - noNetWorkImg.size.width)/2, ALD(200),noNetWorkImg.size.width, noNetWorkImg.size.height)];
        noNetWorkImageView.image = noNetWorkImg;
        [self addSubview:noNetWorkImageView];
        
        UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        refreshButton.frame = CGRectMake((kScreenWidth - ALD(111))/2, noNetWorkImageView.bottom + ALD(16), ALD(111), ALD(31));
        [refreshButton setTitle:@"戳我重新加载" forState:UIControlStateNormal];
        [refreshButton setTitleColor:WJColorDardGray3 forState:UIControlStateNormal];
        refreshButton.layer.cornerRadius = 3;
        refreshButton.layer.borderColor = WJColorDardGray9.CGColor;
        refreshButton.layer.borderWidth = 0.5;
        refreshButton.titleLabel.font = WJFont14;
        [refreshButton addTarget:self action:@selector(refreshButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:refreshButton];


    }
    return self;
}

-(void)refreshButtonAction
{
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(clickRefreshButton)]) {
            [self.delegate clickRefreshButton];
        }
    }
}
@end
