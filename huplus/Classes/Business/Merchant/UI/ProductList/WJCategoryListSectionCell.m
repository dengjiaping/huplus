//
//  WJCategoryListSectionCell.m
//  HuPlus
//
//  Created by XT Xiong on 2017/4/18.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJCategoryListSectionCell.h"



@implementation WJCategoryListSectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = WJColorViewBg;
        self.titleLabel = [[UILabel alloc]initForAutoLayout];
        _titleLabel.textColor = WJColorDardGray3;
        _titleLabel.font = WJFont14;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        [self.contentView addConstraints:[_titleLabel constraintsSize:CGSizeMake(kScreenWidth - 100 - 12, 20)]];
        [self.contentView addConstraint:[_titleLabel constraintCenterYInContainer]];
        [self.contentView addConstraints:[_titleLabel constraintsLeftInContainer:13]];
        
    }
    return self;
}


- (void)configDataWithModel:(WJCategoryListModel *)model
{
    _titleLabel.text = model.categoryName;
}


@end
