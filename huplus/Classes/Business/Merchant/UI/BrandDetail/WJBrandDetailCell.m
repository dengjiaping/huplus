//
//  WJBrandDetailCell.m
//  HuPlus
//
//  Created by XT Xiong on 2017/4/1.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJBrandDetailCell.h"
#import <UIImageView+WebCache.h>

@interface WJBrandDetailCell()

@end


@implementation WJBrandDetailCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = WJColorWhite;
        
        _detailLabel = [[UILabel alloc]initForAutoLayout];
        _detailLabel.font = WJFont14;
        _detailLabel.textColor = WJColorDardGray9;
        _detailLabel.numberOfLines = 3;
        [self.contentView addSubview:_detailLabel];
        
        [self.contentView addConstraints:[_detailLabel constraintsSize:CGSizeMake(kScreenWidth - 20, 60)]];
        [self.contentView addConstraints:[_detailLabel constraintsTopInContainer:5]];
        [self.contentView addConstraints:[_detailLabel constraintsLeftInContainer:10]];
        
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_bottomButton setImage:[UIImage imageNamed:@"brand_more"] forState:UIControlStateNormal];
        [_bottomButton setImage:[UIImage imageNamed:@"brand_fold"] forState:UIControlStateSelected];

//        [self.contentView addSubview:_bottomButton];
//        [self.contentView addConstraint:[_bottomButton constraintCenterXInContainer]];
//        [self.contentView addConstraints:[_bottomButton constraintsBottomInContainer:5]];

    }
    return self;
}

- (void)changeLabelHight
{
    NSString * str = @"我V肯定女看电视剧发数据库萨克的麻烦V饭我V肯定女看电视剧发数据库萨克的麻烦V饭我V肯定女看电视剧发数据库萨克的麻烦V饭我V肯定女看电视剧发数据库萨克的麻烦V饭我V肯定女看电视剧发数据库萨克的麻烦V饭我V肯定女看电视剧发数据库萨克的麻烦V饭我V肯定女看电视剧发数据库萨克的麻烦V饭";
    _bottomButton.selected = !_bottomButton.selected;
    
    if (_bottomButton.selected == YES) {
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenWidth - 20,MAXFLOAT) options:options attributes:@{NSFontAttributeName:WJFont14} context:nil];
        CGFloat realHeight = ceilf(rect.size.height);
        _detailLabel.numberOfLines = 0;
        [self.contentView addConstraints:[_detailLabel constraintsSize:CGSizeMake(kScreenWidth - 20, realHeight)]];
    }else{
        _detailLabel.numberOfLines = 2;
        [self.contentView addConstraints:[_detailLabel constraintsSize:CGSizeMake(kScreenWidth - 20, 40)]];
    }

}


-(void)configData:(WJBrandDetailModel *)brandDetailModel
{
    _detailLabel.text = brandDetailModel.describe;
//    _detailLabel.text = @"我V肯定女看电视剧发数据库萨克的麻烦V饭我V肯定女看电视剧发数据库萨克的麻烦V饭我V肯定女看电视剧发数据库萨克的麻烦V饭我V肯定女看电视剧发数据库萨克的麻烦V饭我V肯定女看电视剧发数据库萨克的麻烦V饭我V肯定女看电视剧发数据库萨克的麻烦V饭我V肯定女看电视剧发数据库萨克的麻烦V饭";
}

@end
