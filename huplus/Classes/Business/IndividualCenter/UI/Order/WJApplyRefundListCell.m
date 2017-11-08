//
//  WJApplyRefundListCell.m
//  HuPlus
//
//  Created by reborn on 17/4/20.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJApplyRefundListCell.h"
#import "WJOrderModel.h"
#import <UIImageView+WebCache.h>
#import "WJProductModel.h"
#import "WJAttributeDetailModel.h"
@interface WJApplyRefundListCell ()
{
    UIImageView *iconIV;
    UILabel     *nameL;
    UILabel     *priceL;
    UILabel     *colorL;
    UILabel     *sizeL;
    
    UILabel     *countL;
    
    UIButton    *applyRefundButton; //申请退款
}

@end

@implementation WJApplyRefundListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(10), ALD(10), ALD(110), ALD(120))];
        iconIV.layer.borderColor = WJColorSeparatorLine.CGColor;
        iconIV.layer.borderWidth = 1;
        iconIV.backgroundColor = [UIColor redColor];
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right+ ALD(15), iconIV.frame.origin.y, kScreenWidth - ALD(139), ALD(44))];
        nameL.numberOfLines = 0;
        nameL.textColor = WJColorDarkGray;
        nameL.font = WJFont15;
        
        colorL =  [[UILabel alloc] initWithFrame:CGRectMake(nameL.origin.x, nameL.bottom, ALD(140), ALD(22))];
        colorL.textColor = WJColorDarkGray;
        colorL.font = WJFont12;
        
        sizeL =  [[UILabel alloc] initWithFrame:CGRectMake(nameL.origin.x, colorL.bottom, kScreenWidth - ALD(139), ALD(22))];
        sizeL.textColor = WJColorDarkGray;
        sizeL.font = WJFont12;
        
        priceL = [[UILabel alloc] initWithFrame:CGRectMake(nameL.origin.x, sizeL.bottom, ALD(100), ALD(22))];
        priceL.textColor = WJColorDarkGray;
        priceL.font = WJFont12;
        
        countL = [[UILabel alloc] initWithFrame:CGRectMake(priceL.right, priceL.frame.origin.y, ALD(40), ALD(22))];
        countL.textColor = WJColorDarkGray;
        countL.font = WJFont12;
        
        
        applyRefundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        applyRefundButton.frame = CGRectMake(kScreenWidth - ALD(10) - ALD(90), sizeL.bottom, ALD(90), ALD(30));
        [applyRefundButton setTitle:@"申请售后" forState:UIControlStateNormal];
        [applyRefundButton setTitleColor:WJColorMainRed forState:UIControlStateNormal];
        applyRefundButton.layer.cornerRadius = 4;
        applyRefundButton.layer.borderColor = WJColorMainRed.CGColor;
        applyRefundButton.layer.borderWidth = 0.5;
        applyRefundButton.titleLabel.font = WJFont14;
        applyRefundButton.hidden = YES;
        [applyRefundButton addTarget:self action:@selector(applyRefundButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:iconIV];
        [self.contentView addSubview:nameL];
        [self.contentView addSubview:colorL];
        [self.contentView addSubview:sizeL];
        [self.contentView addSubview:priceL];
        [self.contentView addSubview:countL];
        [self.contentView addSubview:applyRefundButton];
        
    }
    return self;
}

- (void)configDataWithModel:(WJProductModel *)model isDetail:(BOOL)isDetail
{
    [iconIV sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"bitmap_commodity"]];
    
    WJAttributeDetailModel *sizeAttributeDetailModel =[model.attributeArray firstObject];
    sizeL.text = [NSString stringWithFormat:@"尺寸：%@",sizeAttributeDetailModel.valueName];
    priceL.text = [NSString stringWithFormat:@"¥%@",model.salePrice];
    countL.text = [NSString stringWithFormat:@"x %ld",(long)model.count];
    nameL.text = model.name;
    
    CGSize priceTxtSize = [priceL.text sizeWithAttributes:@{NSFontAttributeName:WJFont12} constrainedToSize:CGSizeMake(1000000, ALD(20))];
    
    priceL.frame = CGRectMake(nameL.origin.x, sizeL.bottom, priceTxtSize.width, ALD(22));
    countL.frame = CGRectMake(priceL.right + ALD(25), priceL.frame.origin.y, ALD(40), ALD(22));
    
    
    if (model.attributeArray.count > 1) {
        
        WJAttributeDetailModel *colorAttributeDetailModel = [model.attributeArray lastObject];
        colorL.text = [NSString stringWithFormat:@"颜色分类：%@",colorAttributeDetailModel.valueName];
    }
    
    countL.text = [NSString stringWithFormat:@"x %ld",model.count];
    if (isDetail) {
        applyRefundButton.hidden = YES;
        
    } else {
        
        applyRefundButton.hidden = NO;
        
        switch (model.productStatus) {
            case OnlyRefundStatusNormal:
            {
                [applyRefundButton setTitle:@"申请退款" forState:UIControlStateNormal];
            }
                break;
                
            case OnlyRefundStatusWaitSellerConfirm:
            {
                [applyRefundButton setTitle:@"待处理" forState:UIControlStateNormal];
                applyRefundButton.userInteractionEnabled = NO;
                [applyRefundButton setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
                applyRefundButton.layer.borderColor = WJColorDardGray9.CGColor;
                
            }
                break;
                
            case OnlyRefundStatusRefundFinish:
            {
                [applyRefundButton setTitle:@"已完成" forState:UIControlStateNormal];
                applyRefundButton.userInteractionEnabled = NO;
                [applyRefundButton setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
                applyRefundButton.layer.borderColor = WJColorDardGray9.CGColor;
                
            }
                break;
                
            case OnlyRefundStatusRefundRefuse:
            {
                [applyRefundButton setTitle:@"已关闭" forState:UIControlStateNormal];
                applyRefundButton.userInteractionEnabled = NO;
                [applyRefundButton setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
                applyRefundButton.layer.borderColor = WJColorDardGray9.CGColor;
                
            }
                break;
                
            case OnlyRefundStatusRefundClose:
            {
                [applyRefundButton setTitle:@"已关闭" forState:UIControlStateNormal];
                applyRefundButton.userInteractionEnabled = NO;
                [applyRefundButton setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
                applyRefundButton.layer.borderColor = WJColorDardGray9.CGColor;
                
            }
                break;
                
            default:
                break;
        }
        
    }
}


#pragma mark - Action

-(void)applyRefundButtonAction
{
    self.applyRefundBlock();
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
