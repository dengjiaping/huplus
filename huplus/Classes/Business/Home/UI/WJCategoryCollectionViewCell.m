//
//  WJCategoryCollectionViewCell.m
//  HuPlus
//
//  Created by reborn on 16/12/19.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJCategoryCollectionViewCell.h"
#import "WJCategoryListModel.h"
#import "UIImageView+WebCache.h"

@interface WJCategoryCollectionViewCell ()
{
    UIImageView *categoryImageView;
    UILabel     *categoryL;
}
@end

@implementation WJCategoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WJColorWhite;

        categoryL = [[UILabel alloc] initForAutoLayout];
        categoryL.font = WJFont13;
        categoryL.textAlignment = NSTextAlignmentCenter;
        categoryL.textColor = WJColorNavigationBar;
        [self.contentView addSubview:categoryL];
        [self.contentView addConstraint:[categoryL constraintHeight:ALD(15)]];
        [self.contentView addConstraints:[categoryL constraintsBottomInContainer:ALD(10)]];
        [self.contentView addConstraints:[categoryL constraintsAssignLeft]];
        [self.contentView addConstraints:[categoryL constraintsAssignRight]];

        categoryImageView = [[UIImageView alloc]initForAutoLayout];
        categoryImageView.backgroundColor = WJColorWhite;
        [self.contentView addSubview:categoryImageView];
        [self.contentView addConstraints:[categoryImageView constraintsSize:CGSizeMake(ALD(25), ALD(25))]];
        [self.contentView addConstraint:[categoryImageView constraintCenterXInContainer]];
        [self.contentView addConstraints:[categoryImageView constraintsBottom:ALD(10) FromView:categoryL]];
    }
    return self;
}

- (void)conFigData:(WJCategoryListModel *)model
{
    [categoryImageView sd_setImageWithURL:[NSURL URLWithString:model.categoryPic] placeholderImage:nil];
    categoryL.text = model.categoryName;
}

- (void)moreCellData
{
    categoryImageView.image = [UIImage imageNamed:@"more_icon"];
    categoryL.text = @"更多";
}

@end
