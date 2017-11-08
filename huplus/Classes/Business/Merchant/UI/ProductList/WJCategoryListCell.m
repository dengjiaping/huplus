//
//  WJCategoryListCell.m
//  HuPlus
//
//  Created by XT Xiong on 2017/2/14.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJCategoryListCell.h"
#import "UIImageView+WebCache.h"

@implementation WJCategoryListCell

- (void)configDataWithModel:(WJCategoryListModel *)model
{
    self.titelLabel.text = model.categoryName;
    UIImage * img = [BitmapCommodityImage resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeStretch];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.categoryPic] placeholderImage:img];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.titelLabel = [[UILabel alloc]initForAutoLayout];
        _titelLabel.font = WJFont14;
        _titelLabel.textColor = WJColorNavigationBar;
        _titelLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titelLabel];
        [self.contentView addConstraints:[_titelLabel constraintsSize:CGSizeMake(self.width, 15)]];
        [self.contentView addConstraint:[_titelLabel constraintCenterXInContainer]];
        [self.contentView addConstraints:[_titelLabel constraintsBottomInContainer:0]];
        
        self.imageView = [[UIImageView alloc]initForAutoLayout];
        [self.contentView addSubview:_imageView];
        [self.contentView addConstraints:[_imageView constraintsBottom:8 FromView:_titelLabel]];
        [self.contentView addConstraints:[_imageView constraintsAssignTop]];
        [self.contentView addConstraints:[_imageView constraintsAssignLeft]];
        [self.contentView addConstraints:[_imageView constraintsAssignRight]];
        
        _imageView.image = [WJUtilityMethod createImageWithColor:WJRandomColor];
    }
    return self;
}
@end
