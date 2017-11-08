//
//  WJProductDetailIntroductionCell.m
//  HuPlus
//
//  Created by XT Xiong on 2017/1/3.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJProductDetailIntroductionCell.h"

@interface WJProductDetailIntroductionCell()
{
    UILabel         * titleLabel;
    UILabel         * priceLabel;
    UILabel         * originalPriceLabel;
    UILabel         * tipsLabel;
    UILabel         * limitLabel;
    
    UIView          * bottomView;
    UIImageView     * firstImgView;
    UIImageView     * secondImgView;
    UIImageView     * thirdImgView;
    
    UILabel         * firstDesL;
    UILabel         * secondDesL;
    UILabel         * thirdDesL;

}


@end

@implementation WJProductDetailIntroductionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = WJColorWhite;

        titleLabel = [[UILabel alloc]initForAutoLayout];
        titleLabel.font = WJFont16;
        titleLabel.textColor = WJColorNavigationBar;
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        [self.contentView addConstraints:[titleLabel constraintsSize:CGSizeMake(kScreenWidth - 24, iPhone6OrThan?39:39)]];
        [self.contentView addConstraints:[titleLabel constraintsTopInContainer:15]];
        [self.contentView addConstraints:[titleLabel constraintsLeftInContainer:12]];
        
        priceLabel = [[UILabel alloc]initForAutoLayout];
        priceLabel.font = WJFont17;
        priceLabel.textColor = WJColorAmount;
        [self.contentView addSubview:priceLabel];
        [self.contentView addConstraints:[priceLabel constraintsTop:10 FromView:titleLabel]];
        [self.contentView addConstraints:[priceLabel constraintsLeftInContainer:12]];
        
        originalPriceLabel = [[UILabel alloc]initForAutoLayout];
        originalPriceLabel.hidden = YES;
        originalPriceLabel.font = WJFont11;
        [self.contentView addSubview:originalPriceLabel];
        [self.contentView addConstraints:[originalPriceLabel constraintsTop:10 FromView:priceLabel]];
        [self.contentView addConstraints:[originalPriceLabel constraintsLeftInContainer:12]];
        
        tipsLabel = [[UILabel alloc]initForAutoLayout];
        tipsLabel.font = WJFont11;
        tipsLabel.textColor = WJColorDardGray9;
        tipsLabel.text = @"线下门店同步销售";
        tipsLabel.hidden = YES;
        [self.contentView addSubview:tipsLabel];
        [self.contentView addConstraints:[tipsLabel constraintsTop:10 FromView:originalPriceLabel]];
        [self.contentView addConstraints:[tipsLabel constraintsLeftInContainer:12]];
        
        bottomView = [[UIView alloc] initForAutoLayout];
        bottomView.backgroundColor = WJColorViewBg;
        bottomView.alpha = 0.6;
        [self.contentView addSubview:bottomView];
        [self.contentView addConstraints:[bottomView constraintsSize:CGSizeMake(kScreenWidth, 40)]];
        [self.contentView addConstraints:[bottomView constraintsLeftInContainer:0]];
        [self.contentView addConstraints:[bottomView constraintsBottomInContainer:0]];
        
        
        firstImgView = [[UIImageView alloc] initForAutoLayout];
        firstImgView.image = [UIImage imageNamed:@"afterSaleDes_icon"];
        [bottomView addSubview:firstImgView];
        [bottomView addConstraints:[firstImgView constraintsLeftInContainer:12]];
        [bottomView addConstraint:[firstImgView constraintCenterYInContainer]];

        
        firstDesL = [[UILabel alloc] initForAutoLayout];
        firstDesL.textColor = WJColorDardGray9;
        firstDesL.font = WJFont12;
        firstDesL.text = @"正品保障";
        [bottomView addSubview:firstDesL];
        [bottomView addConstraints:[firstDesL constraintsLeft:5 FromView:firstImgView]];
        [bottomView addConstraint:[firstDesL constraintCenterYInContainer]];
        
        secondImgView = [[UIImageView alloc] initForAutoLayout];
        secondImgView.image = [UIImage imageNamed:@"afterSaleDes_icon"];
        [bottomView addSubview:secondImgView];
        [bottomView addConstraints:[secondImgView constraintsLeft:25 FromView:firstDesL]];
        [bottomView addConstraint:[secondImgView constraintCenterYInContainer]];
        
        secondDesL = [[UILabel alloc] initForAutoLayout];
        secondDesL.textColor = WJColorDardGray9;
        secondDesL.font = WJFont12;
        secondDesL.text = @"7天无理由退换货";
        [bottomView addSubview:secondDesL];
        [bottomView addConstraints:[secondDesL constraintsLeft:5 FromView:secondImgView]];
        [bottomView addConstraint:[secondDesL constraintCenterYInContainer]];
        
        
        thirdImgView = [[UIImageView alloc] initForAutoLayout];
        thirdImgView.image = [UIImage imageNamed:@"afterSaleDes_icon"];
        [bottomView addSubview:thirdImgView];
        [bottomView addConstraints:[thirdImgView constraintsLeft:25 FromView:secondDesL]];
        [bottomView addConstraint:[thirdImgView constraintCenterYInContainer]];
        
        thirdDesL = [[UILabel alloc] initForAutoLayout];
        thirdDesL.textColor = WJColorDardGray9;
        thirdDesL.font = WJFont12;
        thirdDesL.text = @"24小时发货";
        [bottomView addSubview:thirdDesL];
        [bottomView addConstraints:[thirdDesL constraintsLeft:5 FromView:thirdImgView]];
        [bottomView addConstraint:[thirdDesL constraintCenterYInContainer]];

    }
    return self;
}

-(void)configDataWithName:(NSString *)name price:(NSString *)price originalPrice:(NSString *)originalPrice
{
    titleLabel.text = name;
    priceLabel.text = [NSString stringWithFormat:@"￥%@", [WJUtilityMethod floatNumberForMoneyFomatter:[price floatValue]]];
    if ([originalPrice isEqualToString:@""]) {
        
        originalPriceLabel.hidden = YES;
        originalPriceLabel.text = @"";
        
    } else {
        
        originalPriceLabel.hidden = NO;
        originalPriceLabel.text = [NSString stringWithFormat:@"价格:￥%@", [WJUtilityMethod floatNumberForMoneyFomatter:[originalPrice floatValue]]];
        
        NSString *str = originalPriceLabel.text;
        CGSize txtSize = [str sizeWithAttributes:@{NSFontAttributeName:WJFont11} constrainedToSize:CGSizeMake(1000000, ALD(20))];
        
        UILabel *underLine = [[UILabel alloc] initWithFrame:CGRectMake(ALD(25), ALD(5), txtSize.width - ALD(10), 1)];
        underLine.backgroundColor = WJColorBlack;
        [originalPriceLabel addSubview:underLine];

        
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:originalPriceLabel.text];
//        
//        [attrStr addAttributes:@{NSFontAttributeName:WJFont11,NSForegroundColorAttributeName:WJColorDardGray9} range:NSMakeRange(0,3)];
//        [attrStr addAttributes:@{NSFontAttributeName:WJFont11,NSForegroundColorAttributeName:WJColorDardGray9,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),NSStrikethroughColorAttributeName:WJColorDardGray9} range:NSMakeRange(3, attrStr.length - 3)];
        
//        [attrStr addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0)} range:NSMakeRange(3, attrStr.length - 3)];
        
//        originalPriceLabel.attributedText = attrStr;
        

//        NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:originalPriceLabel.text];
//        [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,originalPriceLabel.text.length)];
//        
//        originalPriceLabel.attributedText = attributeMarket;
    }
}

@end
