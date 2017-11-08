//
//  WJProductDetailBandCell.m
//  HuPlus
//
//  Created by XT Xiong on 2017/1/4.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJProductDetailBandCell.h"
#import <UIImageView+WebCache.h>
@interface WJProductDetailBandCell()
{
    UIImageView * bandIV;
    UILabel     * titltLabel;
    UILabel     * tipsLabel;
}
@end

@implementation WJProductDetailBandCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = WJColorWhite;
        
        bandIV = [[UIImageView alloc]initForAutoLayout];
        [self.contentView addSubview:bandIV];
        [self.contentView addConstraints:[bandIV constraintsSize:CGSizeMake(60, 40)]];
        [self.contentView addConstraints:[bandIV constraintsLeftInContainer:12]];
        [self.contentView addConstraint:[bandIV constraintCenterYInContainer]];
        
        titltLabel = [[UILabel alloc]initForAutoLayout];
        titltLabel.font = WJFont14;
        titltLabel.textColor = WJColorNavigationBar;
        [self.contentView addSubview:titltLabel];
        [self.contentView addConstraint:[titltLabel constraintTopEqualToView:bandIV]];
        [self.contentView addConstraints:[titltLabel constraintsLeft:10 FromView:bandIV]];
        
        tipsLabel = [[UILabel alloc]initForAutoLayout];
        tipsLabel.font = WJFont12;
        tipsLabel.textColor = WJColorDardGray9;
        [self.contentView addSubview:tipsLabel];
        [self.contentView addConstraint:[tipsLabel constraintBottomEqualToView:bandIV]];
        [self.contentView addConstraints:[tipsLabel constraintsLeft:10 FromView:bandIV]];
    }
    return self;
}

-(void)configDataWithImage:(NSString *)imgUrl shopName:(NSString *)name onSaleCount:(NSInteger)count
{
    [bandIV sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"bitmap_brand"]];
    titltLabel.text = name;
    tipsLabel.text = [NSString stringWithFormat:@"在售商品%ld件",count];
}

@end
