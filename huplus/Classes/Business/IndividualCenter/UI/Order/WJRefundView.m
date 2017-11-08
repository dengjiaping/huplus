//
//  WJRefundView.m
//  HuPlus
//
//  Created by reborn on 17/1/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJRefundView.h"

@interface WJRefundView ()
{
    UILabel *refundStatusL;
    UILabel *desL;
    UIView  *lineView;
    UIView  *bgView;
    UILabel *receiverL;
    UILabel *addressL;
    UILabel *phoneL;
}
@end

@implementation WJRefundView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        refundStatusL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(20), kScreenWidth - ALD(21), ALD(22))];
        refundStatusL.text = @"卖家已经同意您的售后申请";
        refundStatusL.font = WJFont16;
        refundStatusL.textColor = WJColorNavigationBar;
        [self addSubview:refundStatusL];
        
        desL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), refundStatusL.bottom + ALD(10), kScreenWidth - ALD(21), ALD(22))];
        desL.text = @"请仔细阅读并按照下面要求邮寄商品，谢谢！";
        desL.font = WJFont14;
        desL.textColor = WJColorLightGray;
        [self addSubview:desL];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), desL.bottom + ALD(10), kScreenWidth - ALD(24), 0.5)];
        lineView.backgroundColor = WJColorSeparatorLine;
        [self addSubview:lineView];
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), lineView.bottom + ALD(10), kScreenWidth - ALD(24), ALD(100))];
        bgView.backgroundColor = WJColorWhite;
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 10;
        [self addSubview:bgView];
        
        
        receiverL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(10), ALD(100), ALD(20))];
        receiverL.text = @"收件人：ANAN";
        receiverL.textColor = WJColorLightGray;
        receiverL.font = WJFont12;
        [bgView addSubview:receiverL];
        
        addressL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(receiverL.frame), receiverL.bottom, bgView.width - ALD(20), ALD(30))];
        addressL.text = @"地址：浙江省杭州市江干区沙文渊北路166号华银教育5楼拆包组";
        addressL.numberOfLines = 0;
        addressL.font = WJFont12;
        addressL.textColor = WJColorLightGray;
        [bgView addSubview:addressL];
        
        phoneL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(addressL.frame), addressL.bottom, bgView.width - ALD(20), ALD(30))];
        phoneL.text = @"电话：0571-87018262";
        phoneL.numberOfLines = 0;
        phoneL.font = WJFont12;
        phoneL.textColor = WJColorLightGray;
        [bgView addSubview:phoneL];
        
    }
    return self;
}

@end
