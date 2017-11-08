//
//  WJRefundCell.m
//  HuPlus
//
//  Created by reborn on 17/1/5.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJRefundCell.h"
#import "WJOrderModel.h"
#import "WJProductModel.h"
#import <UIImageView+WebCache.h>
#import "WJAttributeDetailModel.h"

@interface WJRefundCell ()
{
    UILabel     *orderNoL;
    UILabel     *statusL;
    UIImageView *iconIV;
    UILabel     *nameL;
    UILabel     *priceL;
    UILabel     *colorL;
    UILabel     *sizeL;
    UILabel     *countL;

    UILabel     *applicationTimeL;
    UILabel     *timeL;

    UIButton    *progressButton; //进度查询
//    UIButton    *deliveryAddressButton; //查看邮寄地址
}

@end

@implementation WJRefundCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        orderNoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(10), ALD(250), ALD(30))];
        orderNoL.textColor = WJColorDardGray9;
        orderNoL.font = WJFont12;
        orderNoL.textAlignment = NSTextAlignmentLeft;
        
        statusL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(10) - ALD(100), ALD(10), ALD(100), ALD(30))];
        statusL.textColor = WJColorDardGray9;
        statusL.font = WJFont12;
        statusL.textAlignment = NSTextAlignmentRight;
        
        iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(10), statusL.bottom, ALD(92), ALD(108))];
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
        
        
//        deliveryAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        deliveryAddressButton.frame = CGRectMake(kScreenWidth - ALD(10) - ALD(90), sizeL.bottom, ALD(90), ALD(30));
//        [deliveryAddressButton setTitle:@"查看邮寄地址" forState:UIControlStateNormal];
//        [deliveryAddressButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
//        deliveryAddressButton.layer.cornerRadius = 4;
//        deliveryAddressButton.layer.borderColor = WJColorNavigationBar.CGColor;
//        deliveryAddressButton.layer.borderWidth = 0.5;
//        deliveryAddressButton.hidden = YES;
//        deliveryAddressButton.titleLabel.font = WJFont14;
//        [deliveryAddressButton addTarget:self action:@selector(deliveryAddressButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(ALD(12), iconIV.bottom + ALD(15), kScreenWidth - ALD(24), 0.5f)];
        lineView.backgroundColor = WJColorSeparatorLine;
        
        
        applicationTimeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), lineView.bottom, ALD(80), ALD(30))];
        applicationTimeL.textColor = WJColorDarkGray;
        applicationTimeL.font = WJFont12;
        applicationTimeL.text = @"申请时间";
        
        
        timeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), applicationTimeL.bottom, ALD(150), ALD(30))];
        timeL.textColor = WJColorDarkGray;
        timeL.font = WJFont12;
        
        progressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        progressButton.frame = CGRectMake(kScreenWidth - ALD(10) - ALD(90), lineView.bottom + ALD(10), ALD(90), ALD(30));
        [progressButton setTitle:@"进度查询" forState:UIControlStateNormal];
        [progressButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        progressButton.layer.cornerRadius = 4;
        progressButton.layer.borderColor = WJColorNavigationBar.CGColor;
        progressButton.layer.borderWidth = 0.5;
        progressButton.titleLabel.font = WJFont14;
        [progressButton addTarget:self action:@selector(progressButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.contentView addSubview:orderNoL];
        [self.contentView addSubview:statusL];
        [self.contentView addSubview:iconIV];
        [self.contentView addSubview:nameL];
        [self.contentView addSubview:colorL];
        [self.contentView addSubview:sizeL];
        [self.contentView addSubview:priceL];
        [self.contentView addSubview:countL];
        [self.contentView addSubview:lineView];
        [self.contentView addSubview:applicationTimeL];
        [self.contentView addSubview:timeL];
        [self.contentView addSubview:progressButton];

//        [self.contentView addSubview:deliveryAddressButton];
        
    }
    return self;
}

- (void)configDataWithOrder:(WJOrderModel *)orderModel
{
    orderNoL.text = [NSString stringWithFormat:@"订单编号：%@",orderModel.refundId];
    timeL.text = [NSString stringWithFormat:@"%@",orderModel.refundTime];
    WJProductModel *productModel = [orderModel.productList firstObject];
    
    WJAttributeDetailModel *sizeAttributeDetailModel =[productModel.attributeArray firstObject];
    sizeL.text = [NSString stringWithFormat:@"尺寸：%@",sizeAttributeDetailModel.valueName];
    priceL.text = [NSString stringWithFormat:@"¥%@",productModel.salePrice];
    countL.text = [NSString stringWithFormat:@"x %ld",(long)productModel.count];

    
    CGSize priceTxtSize = [priceL.text sizeWithAttributes:@{NSFontAttributeName:WJFont12} constrainedToSize:CGSizeMake(1000000, ALD(20))];
    
    priceL.frame = CGRectMake(nameL.origin.x, sizeL.bottom, priceTxtSize.width, ALD(22));
    countL.frame = CGRectMake(priceL.right + ALD(25), priceL.frame.origin.y, ALD(40), ALD(22));
    
    if (productModel.attributeArray.count > 1) {
        
        WJAttributeDetailModel *colorAttributeDetailModel = [productModel.attributeArray lastObject];
        colorL.text = [NSString stringWithFormat:@"颜色分类：%@",colorAttributeDetailModel.valueName];
    }
    
    [iconIV sd_setImageWithURL:[NSURL URLWithString:productModel.imageUrl] placeholderImage:[UIImage imageNamed:@"bitmap_commodity"]];
    nameL.text = productModel.name;
    
    ProductStatus productStatus = (ProductStatus)orderModel.orderStatus;

    switch (productStatus) {
            
        case ProductStatusWaitSellerConfirm:
        {
            statusL.text = @"等待商家确认";
        }
            break;
            
        case ProductStatusWaitBuyerSend:
        {

            statusL.text = @"等待买家邮寄";
        }
            break;
            
        case ProductStatusWaitSellerReceive:
        {
            statusL.text = @"等待商家收货";
        }
            break;
            
        case ProductStatusWaitSellerRefund:
        {
            statusL.text = @"等待商家退款";
        }
            break;
        
        case ProductStatusRefundFinish:
        {
            statusL.text = @"退款完成";
        }
            break;
            
        case ProductStatusRefundClose:
        {
            statusL.text = @"退款关闭";
        }
            break;
            
        case ProductStatusRefundRefuse:
        {
            statusL.text = @"拒绝退款";
        }
            break;
            
        case OnlyRefundStatusWaitSellerConfirm:
        {
            statusL.text = @"等待商家退款";
        }
            break;
            
        case OnlyRefundStatusRefundFinish:
        {
            statusL.text = @"退款完成";
        }
            break;
            
        case OnlyRefundStatusRefundRefuse:
        {
            statusL.text = @"拒绝退款";
        }
            break;
            
        case OnlyRefundStatusRefundClose:
        {
            statusL.text = @"退款关闭";
        }
            break;
            
        case OnlyRefundStatusRefunding:
        {
            statusL.text = @"退款中";
        }
            break;
            
            
            
        default:
            break;
    }
    
//    if (orderModel.orderStatus == OrderStatusProcess) {
//        
//        deliveryAddressButton.hidden = NO;
//        
//    } else {
//        deliveryAddressButton.hidden = YES;
//    }

}


#pragma mark - Action

//-(void)deliveryAddressButtonAction
//{
//    self.checkProgress();
//}

-(void)progressButtonAction
{
    self.checkProgress();
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
