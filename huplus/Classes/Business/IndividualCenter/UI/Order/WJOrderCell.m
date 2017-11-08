//
//  WJOrderCell.m
//  HuPlus
//
//  Created by reborn on 16/12/21.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJOrderCell.h"
#import "WJOrderModel.h"
#import <UIImageView+WebCache.h>
#import "WJProductModel.h"
#import "WJAttributeDetailModel.h"
@interface WJOrderCell ()
{
    UIImageView *shopIconIV;
    UILabel     *shopNameL;
    UIImageView *rightArrowIV;
    
    UILabel     *orderNoL;
    UILabel     *statusL;
    
    UIImageView *iconIV;
    UIImageView *secondIconIV;
    UIImageView *thirdIconIV;
    

    UILabel     *nameL;
    UILabel     *priceL;
    UILabel     *colorL;
    UILabel     *sizeL;
    UILabel     *countL;
    
    UIButton    *payRightNowButton;     //立即付款
    UIButton    *ConfirmReceiveButton;  //确认收货
    UIButton    *checkLogisticseButton; //检查物流
    UIButton    *cancelOrderButton;     //取消订单

    
    UIButton    *checkMoreButton;       //查看更多

    UILabel     *countDescriptionL;     //数量描述
    UILabel     *totalMoneyL;
}
@end

@implementation WJOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        UIImage *shopImage = [UIImage imageNamed:@"shopIcon"];
//        shopIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), ALD(16), shopImage.size.width, shopImage.size.height)];
//        shopIconIV.image = shopImage;
//        
//        shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(shopIconIV.right + ALD(10), ALD(12), ALD(100), ALD(20))];
//        shopNameL.userInteractionEnabled = YES;
//        shopNameL.textColor = WJColorDardGray6;
//        shopNameL.font = WJFont12;
//        shopNameL.textAlignment = NSTextAlignmentLeft;
//        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShopGesture)];
//        [shopNameL  addGestureRecognizer:tapGesture];
//        
//
//        rightArrowIV = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        orderNoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(10), ALD(250), ALD(20))];
        orderNoL.textColor = WJColorDarkGray;
        orderNoL.font = WJFont12;
        orderNoL.textAlignment = NSTextAlignmentLeft;

        statusL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(10) - ALD(100), ALD(10), ALD(100), ALD(30))];
        statusL.textColor = WJColorMainRed;
        statusL.font = WJFont12;
        statusL.textAlignment = NSTextAlignmentRight;
        
        iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(5), statusL.bottom, ALD(92), ALD(108))];
        iconIV.layer.borderColor = WJColorSeparatorLine.CGColor;
        iconIV.layer.borderWidth = 0.5f;
        iconIV.hidden = NO;
        
        secondIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(iconIV.right + ALD(5), statusL.bottom, ALD(92), ALD(108))];
        secondIconIV.layer.borderColor = WJColorSeparatorLine.CGColor;
        secondIconIV.layer.borderWidth = 0.5f;
        secondIconIV.hidden = YES;
        
        thirdIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(secondIconIV.right + ALD(5), statusL.bottom, ALD(92), ALD(108))];
        thirdIconIV.layer.borderColor = WJColorSeparatorLine.CGColor;
        thirdIconIV.layer.borderWidth = 0.5f;
        thirdIconIV.hidden = YES;
        
        checkMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        checkMoreButton.titleLabel.font = WJFont12;
        checkMoreButton.titleLabel.numberOfLines = 0;
        checkMoreButton.frame = CGRectMake(thirdIconIV.right + ALD(5), statusL.bottom, ALD(92), ALD(108));
        [checkMoreButton setTitle:@"查看\n更多" forState:UIControlStateNormal];
        [checkMoreButton setImage:[UIImage imageNamed:@"order_more_icon"] forState:UIControlStateNormal];
        [checkMoreButton setTitleEdgeInsets:UIEdgeInsetsMake(-ALD(10), 0, 0, ALD(20))];
        [checkMoreButton setImageEdgeInsets:UIEdgeInsetsMake(ALD(70),ALD(30), ALD(10), ALD(20))];
        [checkMoreButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        checkMoreButton.titleLabel.font = WJFont14;
        checkMoreButton.hidden = YES;
        checkMoreButton.backgroundColor = WJColorViewBg;
        [checkMoreButton addTarget:self action:@selector(checkMoreButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right+ ALD(15), iconIV.frame.origin.y, kScreenWidth - ALD(139), ALD(22))];
        nameL.textColor = WJColorDarkGray;
        nameL.font = WJFont15;
        
        colorL =  [[UILabel alloc] initWithFrame:CGRectMake(nameL.origin.x, nameL.bottom, ALD(140), ALD(22))];
        colorL.textColor = WJColorDarkGray;
        colorL.font = WJFont12;
        
        sizeL =  [[UILabel alloc] initWithFrame:CGRectMake(nameL.origin.x, colorL.bottom, kScreenWidth - ALD(139), ALD(22))];
        sizeL.textColor = WJColorDarkGray;
        sizeL.font = WJFont12;
        
        priceL = [[UILabel alloc] initWithFrame:CGRectMake(nameL.origin.x, sizeL.bottom, ALD(180), ALD(22))];
        priceL.textColor = WJColorDarkGray;
        priceL.font = WJFont12;
        
        countL = [[UILabel alloc] initWithFrame:CGRectMake(priceL.right, sizeL.bottom, ALD(40), ALD(22))];
        countL.textColor = WJColorDarkGray;
        countL.font = WJFont12;
        
        
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(ALD(12), iconIV.bottom + ALD(15), kScreenWidth - ALD(24), 0.5f)];
        lineView.backgroundColor = WJColorSeparatorLine;

        
        countDescriptionL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), lineView.bottom, ALD(80), ALD(30))];
        countDescriptionL.textColor = WJColorDarkGray;
        countDescriptionL.font = WJFont12;
        
        
        totalMoneyL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), countDescriptionL.bottom, ALD(100), ALD(30))];
        totalMoneyL.textColor = WJColorDarkGray;
        totalMoneyL.font = WJFont12;
        
        
        payRightNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        payRightNowButton.frame = CGRectMake(kScreenWidth - ALD(10) - ALD(90), lineView.bottom + ALD(10), ALD(90), ALD(30));
        [payRightNowButton setTitle:@"立即付款" forState:UIControlStateNormal];
        [payRightNowButton setTitleColor:WJColorMainRed forState:UIControlStateNormal];
        payRightNowButton.layer.cornerRadius = 4;
        payRightNowButton.layer.borderColor = WJColorMainRed.CGColor;
        payRightNowButton.layer.borderWidth = 0.5;
        payRightNowButton.titleLabel.font = WJFont14;
        payRightNowButton.hidden = YES;
        [payRightNowButton addTarget:self action:@selector(payRightNowButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        ConfirmReceiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        ConfirmReceiveButton.frame = CGRectMake(kScreenWidth - ALD(10) - ALD(90), lineView.bottom + ALD(10), ALD(90), ALD(30));
        [ConfirmReceiveButton setTitle:@"确认收货" forState:UIControlStateNormal];
        [ConfirmReceiveButton setTitleColor:WJColorMainRed forState:UIControlStateNormal];
        ConfirmReceiveButton.layer.cornerRadius = 4;
        ConfirmReceiveButton.layer.borderColor = WJColorMainRed.CGColor;
        ConfirmReceiveButton.layer.borderWidth = 0.5;
        ConfirmReceiveButton.titleLabel.font = WJFont14;
        ConfirmReceiveButton.hidden = YES;
        [ConfirmReceiveButton addTarget:self action:@selector(ConfirmReceiveButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        checkLogisticseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        checkLogisticseButton.frame = CGRectMake((kScreenWidth - ConfirmReceiveButton.width * 2 - ALD(15)), CGRectGetMinY(ConfirmReceiveButton.frame), ALD(90), ALD(30));
        [checkLogisticseButton setTitle:@"查看物流" forState:UIControlStateNormal];
        [checkLogisticseButton setTitleColor:WJColorMainRed forState:UIControlStateNormal];
        checkLogisticseButton.layer.cornerRadius = 4;
        checkLogisticseButton.layer.borderColor = WJColorMainRed.CGColor;
        checkLogisticseButton.layer.borderWidth = 0.5;
        checkLogisticseButton.titleLabel.font = WJFont14;
        checkLogisticseButton.hidden = YES;
        [checkLogisticseButton addTarget:self action:@selector(checkLogisticseButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        cancelOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelOrderButton.frame = CGRectMake(kScreenWidth - ALD(10) - ALD(90), lineView.bottom + ALD(10), ALD(90), ALD(30));
        [cancelOrderButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [cancelOrderButton setTitleColor:WJColorMainRed forState:UIControlStateNormal];
        cancelOrderButton.layer.cornerRadius = 4;
        cancelOrderButton.layer.borderColor = WJColorMainRed.CGColor;
        cancelOrderButton.layer.borderWidth = 0.5;
        cancelOrderButton.titleLabel.font = WJFont14;
        cancelOrderButton.hidden = YES;
        [cancelOrderButton addTarget:self action:@selector(cancelOrderButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:orderNoL];
//        [self.contentView addSubview:shopIconIV];
//        [self.contentView addSubview:shopNameL];
//        [self.contentView addSubview:rightArrowIV];
        [self.contentView addSubview:statusL];
        [self.contentView addSubview:iconIV];
        [self.contentView addSubview:secondIconIV];
        [self.contentView addSubview:thirdIconIV];
        [self.contentView addSubview:checkMoreButton];
        [self.contentView addSubview:nameL];
        [self.contentView addSubview:colorL];
        [self.contentView addSubview:sizeL];
        [self.contentView addSubview:priceL];
        [self.contentView addSubview:countL];
        [self.contentView addSubview:lineView];
        [self.contentView addSubview:countDescriptionL];
        [self.contentView addSubview:totalMoneyL];
        [self.contentView addSubview:payRightNowButton];
        [self.contentView addSubview:ConfirmReceiveButton];
        [self.contentView addSubview:checkLogisticseButton];
        [self.contentView addSubview:cancelOrderButton];

    }
    return self;
}

- (void)configDataWithOrder:(WJOrderModel *)orderModel
{
//    shopNameL.text = orderModel.orderStoreModel.shopName;
//    CGSize txtSize = [shopNameL.text sizeWithAttributes:@{NSFontAttributeName:WJFont12} constrainedToSize:CGSizeMake(1000000, ALD(20))];
//    shopNameL.frame = CGRectMake(shopIconIV.right + ALD(10), ALD(12), txtSize.width, ALD(20));
    
    orderNoL.text = [NSString stringWithFormat:@"订单编号：%@",orderModel.orderNo];
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

    
//    UIImage *image = [UIImage imageNamed:@"icon_arrow_right"];
//    rightArrowIV.frame = CGRectMake(shopNameL.right + ALD(10), (ALD(44) - image.size.height)/2, image.size.width, image.size.height);
//    rightArrowIV.image = image;
    
    [iconIV sd_setImageWithURL:[NSURL URLWithString:productModel.imageUrl] placeholderImage:[UIImage imageNamed:@"bitmap_commodity"]];
    nameL.text = productModel.name;
    
    countDescriptionL.text = [NSString stringWithFormat:@"共%ld件商品",(long)orderModel.totalCount];
    totalMoneyL.text = [NSString stringWithFormat:@"合计: ¥%@",orderModel.PayAmount];
    
    switch (orderModel.orderStatus) {
        case OrderStatusSuccess:
        {
            statusL.text = @"已完成";
            cancelOrderButton.hidden = YES;
            payRightNowButton.hidden = YES;
            checkLogisticseButton.hidden = YES;
            ConfirmReceiveButton.hidden = YES;
        }
            break;
            
        case OrderStatusUnfinished:
        {
            checkLogisticseButton.hidden = YES;
            ConfirmReceiveButton.hidden = YES;
            payRightNowButton.hidden = NO;
            cancelOrderButton.hidden = YES;
            statusL.text = @"待支付";
        }
            break;
            
        case OrderStatusWaitReceive:
        {
            checkLogisticseButton.hidden = NO;
            ConfirmReceiveButton.hidden = NO;
            payRightNowButton.hidden = YES;
            statusL.text = @"卖家已发货";
        }
            break;
            
        case OrderStatusWaitDeliver:
        {
            cancelOrderButton.hidden = YES;
            payRightNowButton.hidden = YES;
            checkLogisticseButton.hidden = YES;
            ConfirmReceiveButton.hidden = YES;
            statusL.text = @"待发货";
        }
            break;
            
        case OrderStatusClose:
        {
            cancelOrderButton.hidden = YES;
            payRightNowButton.hidden = YES;
            checkLogisticseButton.hidden = YES;
            ConfirmReceiveButton.hidden = YES;
            statusL.text = @"已关闭";
        }
            break;
            
        default:
            break;
    }
    
    if (orderModel.productList.count == 2) {
        
        secondIconIV.hidden = NO;
        [self hideContent];

        WJProductModel *secondProductModel = [orderModel.productList objectAtIndex:1];
        [secondIconIV sd_setImageWithURL:[NSURL URLWithString:secondProductModel.imageUrl] placeholderImage:[UIImage imageNamed:@"bitmap_commodity"]];

        
    } else if (orderModel.productList.count == 3) {
        
        secondIconIV.hidden = NO;
        thirdIconIV.hidden = NO;
        [self hideContent];
        
        WJProductModel *secondProductModel = [orderModel.productList objectAtIndex:1];
        [secondIconIV sd_setImageWithURL:[NSURL URLWithString:secondProductModel.imageUrl] placeholderImage:[UIImage imageNamed:@"bitmap_commodity"]];
        
        WJProductModel *thirdProductModel = [orderModel.productList objectAtIndex:2];
        [thirdIconIV sd_setImageWithURL:[NSURL URLWithString:thirdProductModel.imageUrl] placeholderImage:[UIImage imageNamed:@"bitmap_commodity"]];


    } else if (orderModel.productList.count > 3) {
        
        secondIconIV.hidden = NO;
        thirdIconIV.hidden = NO;
        checkMoreButton.hidden = NO;
        [self hideContent];
        
        WJProductModel *secondProductModel = [orderModel.productList objectAtIndex:1];
        [secondIconIV sd_setImageWithURL:[NSURL URLWithString:secondProductModel.imageUrl] placeholderImage:[UIImage imageNamed:@"bitmap_commodity"]];
        
        WJProductModel *thirdProductModel = [orderModel.productList objectAtIndex:2];
        [thirdIconIV sd_setImageWithURL:[NSURL URLWithString:thirdProductModel.imageUrl] placeholderImage:[UIImage imageNamed:@"bitmap_commodity"]];

    }
}

-(void)hideContent
{
    nameL.hidden = YES;
    colorL.hidden = YES;
    sizeL.hidden = YES;
    priceL.hidden = YES;
    colorL.hidden = YES;
    countL.hidden = YES;
}

#pragma mark - Action
-(void)payRightNowButtonAction
{
    
    self.payRightNowBlock();
}

-(void)ConfirmReceiveButtonAction
{
    self.ConfirmReceiveBlock();
}

-(void)checkLogisticseButtonAction
{
    self.checkLogisticseBlock();
}

-(void)cancelOrderButtonAction
{
    self.cancelOrderBlock();
}

-(void)checkMoreButtonAction
{
    self.checkMoreBlock();
}

-(void)tapShopGesture
{
    self.tapShopBlock();
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
