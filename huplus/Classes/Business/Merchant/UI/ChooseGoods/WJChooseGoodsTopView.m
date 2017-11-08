//
//  WJChooseGoodsBGView.m
//  HuPlus
//
//  Created by XT Xiong on 2017/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJChooseGoodsTopView.h"
#import "WJProductDetailModel.h"
#import <UIImageView+WebCache.h>
@implementation WJChooseGoodsTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI:frame];
    }
    return self;
}

- (void)addUI:(CGRect)frame
{
    self.backgroundColor = WJColorWhite;
    
    _imageView = [[UIImageView alloc]initForAutoLayout];
    _imageView.image = [WJUtilityMethod createImageWithColor:WJColorCardRed];
    [self addSubview:_imageView];
    [self addConstraints:[_imageView constraintsSize:CGSizeMake(87, 102)]];
    [self addConstraints:[_imageView constraintsTopInContainer:20]];
    [self addConstraints:[_imageView constraintsLeftInContainer:15]];

    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_backButton setImage:[UIImage imageNamed:@"shopBack_icon"] forState:UIControlStateNormal];
    [self addSubview:_backButton];
    [self addConstraints:[_backButton constraintsSize:CGSizeMake(20, 20)]];
    [self addConstraints:[_backButton constraintsTopInContainer:20]];
    [self addConstraints:[_backButton constraintsRightInContainer:15]];
    
    _titleLabel = [[UILabel alloc]initForAutoLayout];
    _titleLabel.font = WJFont16;
    _titleLabel.textColor = WJColorNavigationBar;
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_titleLabel];
    [self addConstraints:[_titleLabel constraintsTopInContainer:25]];
    [self addConstraint:[_titleLabel constraintHeight:40]];
    [self addConstraints:[_titleLabel constraintsLeft:10 FromView:_imageView]];
    [self addConstraints:[_titleLabel constraintsRight:28 FromView:_backButton]];
    
    _priceLabel = [[UILabel alloc]initForAutoLayout];
    _priceLabel.font = WJFont16;
    _priceLabel.textColor = WJColorMainRed;
    [self addSubview:_priceLabel];
    [self addConstraints:[_priceLabel constraintsTop:15 FromView:_titleLabel]];
    [self addConstraints:[_priceLabel constraintsLeft:10 FromView:_imageView]];
    
    _originalPriceLabel = [[UILabel alloc]initForAutoLayout];
    [self addSubview:_originalPriceLabel];
    [self addConstraint:[_originalPriceLabel constraintBottomEqualToView:_priceLabel]];
    [self addConstraints:[_originalPriceLabel constraintsLeft:10 FromView:_priceLabel]];

    _stockLabel = [[UILabel alloc]initForAutoLayout];
    _stockLabel.font = WJFont11;
    _stockLabel.textColor = WJColorDardGray9;
    [self addSubview:_stockLabel];
    [self addConstraints:[_stockLabel constraintsTop:12 FromView:_priceLabel]];
    [self addConstraints:[_stockLabel constraintsLeft:10 FromView:_imageView]];

}

-(void)configChooseViewWithModel:(WJProductDetailModel *)model
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.productPic] placeholderImage:BitmapCommodityImage];
    _titleLabel.text = model.productName;
    _priceLabel.text = [NSString stringWithFormat:@"价格:￥%.2f",[model.price floatValue]];
    _originalPriceLabel.text = [NSString stringWithFormat:@"价格:￥%.2f",[model.originalPrice floatValue]];
    _stockLabel.text = [NSString stringWithFormat:@"库存:%@件",model.stock];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:_originalPriceLabel.text];
    [attrStr addAttributes:@{NSFontAttributeName:WJFont11,NSForegroundColorAttributeName:WJColorDardGray9} range:NSMakeRange(0,3)];
    [attrStr addAttributes:@{NSFontAttributeName:WJFont11,NSForegroundColorAttributeName:WJColorDardGray9,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),NSStrikethroughColorAttributeName:WJColorDardGray9} range:NSMakeRange(3, attrStr.length - 3)];
    _originalPriceLabel.attributedText = attrStr;
    
}

@end
