//
//  WJOrderDetailCell.m
//  HuPlus
//
//  Created by reborn on 16/12/28.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJOrderDetailCell.h"
#import "WJOrderModel.h"
#import <UIImageView+WebCache.h>
#import "WJProductModel.h"
#import "WJAttributeDetailModel.h"

@interface WJOrderDetailCell ()
{
    UIImageView *iconIV;
    UILabel     *nameL;
    UILabel     *colorL;
    UILabel     *sizeL;
    UILabel     *amountL;
    UILabel     *countL;
}

@end

@implementation WJOrderDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(10), ALD(15), ALD(100), ALD(110))];
        
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right + ALD(15), ALD(15), kScreenWidth - ALD(127), ALD(40))];
        nameL.textColor = WJColorNavigationBar;
        nameL.numberOfLines = 0;
        nameL.font = WJFont13;

        
        colorL = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right + ALD(15), nameL.bottom, ALD(100), ALD(20))];
        colorL.textColor = WJColorLightGray;
        colorL.font = WJFont12;
        
        
        sizeL = [[UILabel alloc] initWithFrame:CGRectMake(colorL.frame.origin.x, colorL.bottom, ALD(100), ALD(20))];
        sizeL.textColor = WJColorLightGray;
        sizeL.font = WJFont12;
        
        amountL = [[UILabel alloc] initWithFrame:CGRectMake(sizeL.frame.origin.x, sizeL.bottom + ALD(20), ALD(80), ALD(20))];
        amountL.textColor = WJColorLightGray;
        amountL.font = WJFont12;
        
        countL = [[UILabel alloc] initWithFrame:CGRectMake(amountL.right, amountL.frame.origin.y, ALD(80), ALD(20))];
        countL.textColor = WJColorLightGray;
        countL.font = WJFont12;
        
        
        [self addSubview:iconIV];
        [self addSubview:nameL];
        [self addSubview:colorL];
        [self addSubview:sizeL];
        [self addSubview:amountL];
        [self addSubview:countL];

    }
    return self;
}

- (void)configDataWithProduct:(WJProductModel *)model
{
    [iconIV sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"bitmap_commodity"]];
    nameL.text = model.name;

    amountL.text = [NSString stringWithFormat:@"￥%@", [WJUtilityMethod floatNumberForMoneyFomatter:[model.salePrice floatValue]]];

    countL.text = [NSString stringWithFormat:@"x %ld",model.count];
    
    for (WJAttributeDetailModel *attributeDetailModel in model.attributeArray) {
        
        if ([attributeDetailModel.attributeName isEqualToString:@"颜色"]) {
            
            colorL.text = [NSString stringWithFormat:@"颜色：%@",attributeDetailModel.valueName];
        } else {
            
            sizeL.text = [NSString stringWithFormat:@"尺寸：%@",attributeDetailModel.valueName];

        }
    }
    
    CGSize txtSize = [amountL.text sizeWithAttributes:@{NSFontAttributeName:WJFont12} constrainedToSize:CGSizeMake(1000000, ALD(20))];
    
    amountL.frame = CGRectMake(sizeL.frame.origin.x, sizeL.bottom + ALD(10), txtSize.width, ALD(20));
    countL.frame = CGRectMake(amountL.right + ALD(25), amountL.frame.origin.y, ALD(40), ALD(22));

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
