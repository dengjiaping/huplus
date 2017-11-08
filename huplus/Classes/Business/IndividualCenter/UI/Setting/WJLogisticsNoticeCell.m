//
//  WJLogisticsNoticeCell.m
//  HuPlus
//
//  Created by reborn on 17/2/25.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJLogisticsNoticeCell.h"
#import "WJSystemNewsModel.h"
#import <UIImageView+WebCache.h>
@interface WJLogisticsNoticeCell ()
{
    UILabel           *titleL;
    UIImageView       *productIV;
    UILabel           *contentL;
    UILabel           *orderNoL;
    UILabel           *timeL;
    UIView            *bgView;
}
@end

@implementation WJLogisticsNoticeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = WJColorViewBg2;

        
        timeL = [[UILabel alloc] initWithFrame:CGRectZero];
        timeL.textAlignment = NSTextAlignmentCenter;
        timeL.font = WJFont12;
        timeL.textColor = WJColorLightGray;
        
        bgView = [[UIView alloc] initWithFrame:CGRectZero];
        bgView.backgroundColor = WJColorWhite;
        bgView.layer.cornerRadius = ALD(4);
        bgView.layer.masksToBounds = YES;
        
        titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.font = WJFont16;
        titleL.textColor =WJColorNavigationBar;
        
        
        contentL = [[UILabel alloc] initWithFrame:CGRectZero];
        contentL.textAlignment = NSTextAlignmentLeft;
        contentL.lineBreakMode = NSLineBreakByWordWrapping;
        contentL.numberOfLines = 0;
        contentL.font          = WJFont14;
        contentL.textColor     = WJColorDarkGray;
        
        productIV = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        orderNoL = [[UILabel alloc] initWithFrame:CGRectZero];
        orderNoL.textColor = WJColorDardGray6;
        orderNoL.font = WJFont13;
        
        
        [self.contentView addSubview:timeL];
        [self.contentView addSubview:bgView];
        [bgView addSubview:titleL];
        [bgView addSubview:contentL];
        [bgView addSubview:productIV];
        [bgView addSubview:orderNoL];
        
    }
    return self;
}

- (void)configData:(WJSystemNewsModel *)model{
    
    timeL.text  = [NSString stringWithFormat:@"%@",model.date];
    titleL.text = model.title;
    contentL.text = model.goodsName;
    orderNoL.text = [NSString stringWithFormat:@"订单编号：%@",model.orderNo];
    [productIV sd_setImageWithURL:[NSURL URLWithString:model.productImgUrl] placeholderImage:[UIImage imageNamed:@"bitmap_commodity"]];
    
    timeL.frame = CGRectMake((kScreenWidth - ALD(200))/2,ALD(10), ALD(200), ALD(15));
    bgView.frame = CGRectMake(ALD(12), timeL.bottom + ALD(5), kScreenWidth - ALD(24),(130));
    titleL.frame = CGRectMake(ALD(12), ALD(10), ALD(kScreenWidth - ALD(34)), ALD(20));
    productIV.frame = CGRectMake(CGRectGetMinX(titleL.frame), titleL.bottom + ALD(5), ALD(70), ALD(70));
    contentL.frame  = CGRectMake(productIV.right + ALD(15), titleL.bottom + ALD(10), kScreenWidth - ALD(105), ALD(20));
    orderNoL.frame = CGRectMake(CGRectGetMinX(contentL.frame), contentL.bottom + ALD(10), kScreenWidth - ALD(75), ALD(20));

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
