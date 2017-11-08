//
//  WJAfterSalesCell.m
//  HuPlus
//
//  Created by reborn on 16/12/29.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJAfterSalesCell.h"
#import "WJOrderModel.h"
#import <UIImageView+WebCache.h>
#import "WJProductModel.h"
#import "WJAttributeDetailModel.h"
@interface WJAfterSalesCell()
{
    UILabel     *orderNoL;
    UILabel     *statusL;
    UIImageView *iconIV;
    UILabel     *nameL;
    UILabel     *priceL;
    UILabel     *colorL;
    UILabel     *sizeL;
    
    UILabel     *countL;
    
    UIButton    *afterSaleApplyButton; //申请售后
}
@end

@implementation WJAfterSalesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        orderNoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(10), ALD(150), ALD(30))];
//        orderNoL.textColor = WJColorDardGray9;
//        orderNoL.font = WJFont12;
//        orderNoL.text = @"订单编号：52727382639";
//        orderNoL.textAlignment = NSTextAlignmentLeft;
//        
//        statusL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(10) - ALD(100), ALD(10), ALD(100), ALD(30))];
//        statusL.textColor = WJColorDardGray9;
//        statusL.font = WJFont12;
//        statusL.text = @"完成";
//        statusL.textAlignment = NSTextAlignmentRight;
        
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
        
        
        afterSaleApplyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        afterSaleApplyButton.frame = CGRectMake(kScreenWidth - ALD(10) - ALD(90), sizeL.bottom, ALD(90), ALD(30));
        [afterSaleApplyButton setTitle:@"申请售后" forState:UIControlStateNormal];
        [afterSaleApplyButton setTitleColor:WJColorMainRed forState:UIControlStateNormal];
        afterSaleApplyButton.layer.cornerRadius = 4;
        afterSaleApplyButton.layer.borderColor = WJColorMainRed.CGColor;
        afterSaleApplyButton.layer.borderWidth = 0.5;
        afterSaleApplyButton.titleLabel.font = WJFont14;
        afterSaleApplyButton.hidden = YES;
        [afterSaleApplyButton addTarget:self action:@selector(afterSaleApplyButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
//        [self.contentView addSubview:orderNoL];
//        [self.contentView addSubview:statusL];
        [self.contentView addSubview:iconIV];
        [self.contentView addSubview:nameL];
        [self.contentView addSubview:colorL];
        [self.contentView addSubview:sizeL];
        [self.contentView addSubview:priceL];
        [self.contentView addSubview:countL];
        [self.contentView addSubview:afterSaleApplyButton];

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
        afterSaleApplyButton.hidden = YES;
        
    } else {
        
        afterSaleApplyButton.hidden = NO;
        
        switch (model.productStatus) {
            case ProductStatusNormal:
            {
                [afterSaleApplyButton setTitle:@"申请售后" forState:UIControlStateNormal];
            }
                break;
                
            case ProductStatusWaitSellerConfirm:
            {
                [afterSaleApplyButton setTitle:@"退款中" forState:UIControlStateNormal];
                afterSaleApplyButton.userInteractionEnabled = NO;
                [afterSaleApplyButton setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
                afterSaleApplyButton.layer.borderColor = WJColorDardGray9.CGColor;
                
            }
                break;
                
            case ProductStatusWaitBuyerSend:
            {
                [afterSaleApplyButton setTitle:@"退款中" forState:UIControlStateNormal];
                afterSaleApplyButton.userInteractionEnabled = NO;
                [afterSaleApplyButton setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
                afterSaleApplyButton.layer.borderColor = WJColorDardGray9.CGColor;
                
            }
                break;
                
            case ProductStatusWaitSellerReceive:
            {
                [afterSaleApplyButton setTitle:@"退款中" forState:UIControlStateNormal];
                afterSaleApplyButton.userInteractionEnabled = NO;
                [afterSaleApplyButton setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
                afterSaleApplyButton.layer.borderColor = WJColorDardGray9.CGColor;
                
            }
                break;
        
            case ProductStatusWaitSellerRefund:
            {
                [afterSaleApplyButton setTitle:@"退款中" forState:UIControlStateNormal];
                afterSaleApplyButton.userInteractionEnabled = NO;
                [afterSaleApplyButton setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
                afterSaleApplyButton.layer.borderColor = WJColorDardGray9.CGColor;
                
            }
                break;
                
            case ProductStatusRefundFinish:
            {
                [afterSaleApplyButton setTitle:@"已完成" forState:UIControlStateNormal];
                afterSaleApplyButton.userInteractionEnabled = NO;
                [afterSaleApplyButton setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
                afterSaleApplyButton.layer.borderColor = WJColorDardGray9.CGColor;
                
            }
                break;
                
            case ProductStatusRefundClose:
            {
                [afterSaleApplyButton setTitle:@"已关闭" forState:UIControlStateNormal];
                afterSaleApplyButton.userInteractionEnabled = NO;
                [afterSaleApplyButton setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
                afterSaleApplyButton.layer.borderColor = WJColorDardGray9.CGColor;
                
            }
                break;
                
            case ProductStatusRefundRefuse:
            {
                [afterSaleApplyButton setTitle:@"已关闭" forState:UIControlStateNormal];
                afterSaleApplyButton.userInteractionEnabled = NO;
                [afterSaleApplyButton setTitleColor:WJColorDardGray9 forState:UIControlStateNormal];
                afterSaleApplyButton.layer.borderColor = WJColorDardGray9.CGColor;
                
            }
                break;
                
            default:
                break;
        }
        
    }
}


#pragma mark - Action

-(void)afterSaleApplyButtonAction
{
    self.afterSaleApplyBlock();
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
