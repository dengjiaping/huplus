//
//  WJHotRecommendCell.m
//  HuPlus
//
//  Created by XT Xiong on 2017/1/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJHotRecommendCell.h"

@implementation WJHotRecommendCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bottomLine = [[UIView alloc]initForAutoLayout];
        bottomLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:bottomLine];
        [self.contentView addConstraints:[bottomLine constraintsSize:CGSizeMake(kScreenWidth - 20, 0.5)]];
        [self.contentView addConstraints:[bottomLine constraintsLeftInContainer:10]];
        [self.contentView addConstraints:[bottomLine constraintsBottomInContainer:0]];

        UILabel * hotRecLabel = [[UILabel alloc]initForAutoLayout];
        hotRecLabel.text = @"热门推荐";
        hotRecLabel.textColor = WJColorNavigationBar;
        hotRecLabel.font = WJFont14;
        [self.contentView addSubview:hotRecLabel];
        [self.contentView addConstraints:[hotRecLabel constraintsLeftInContainer:10]];
        [self.contentView addConstraint:[hotRecLabel constraintCenterYInContainer]];
        
        self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        _moreButton.titleLabel.font = WJFont12;
        [_moreButton setTitleColor:WJColorViewNotEditable forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"icon_arrow_right"] forState:UIControlStateNormal];
        _moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
        [self.contentView addSubview:self.moreButton];
        [self.contentView addConstraints:[_moreButton constraintsSize:CGSizeMake(45, 20)]];
        [self.contentView addConstraints:[_moreButton constraintsRightInContainer:10]];
        [self.contentView addConstraint:[_moreButton constraintCenterYInContainer]];
    }
    return self;
}

@end
