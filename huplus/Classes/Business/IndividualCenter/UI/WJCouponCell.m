//
//  WJCouponCell.m
//  HuPlus
//
//  Created by reborn on 16/12/25.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJCouponCell.h"
#import "WJCouponModel.h"
@interface WJCouponCell ()
{
    UIImageView *bgImageView;
    UILabel *amountL;
    UILabel *couponDes;
    UILabel *nameL;
    UILabel *useTimeL;
    UIImageView *statusImageView;
    UIImageView *singleSelectImageView;
}

@end

@implementation WJCouponCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
                
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(15), 0, kScreenWidth - ALD(30), ALD(85))];
        bgImageView.backgroundColor = WJColorWhite;
        
        amountL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(10), ALD(80), ALD(40))];
        amountL.textAlignment = NSTextAlignmentCenter;
        amountL.text = @"500";
        amountL.font = WJFont20;
        
        couponDes = [[UILabel alloc] initWithFrame:CGRectMake(amountL.frame.origin.x, amountL.bottom, ALD(100), ALD(20))];
        couponDes.text = @"满1000元可用";
        couponDes.font = WJFont12;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(couponDes.right + ALD(10), ALD(10), 1, ALD(60))];
        lineView.backgroundColor = WJColorSeparatorLine;
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right + ALD(10), ALD(20), ALD(130), ALD(20))];
        nameL.text = @"虎都男装";
        nameL.font = WJFont14;
        
        useTimeL = [[UILabel alloc] initWithFrame:CGRectMake(nameL.frame.origin.x, nameL.bottom + ALD(10), ALD(180), ALD(20))];
        useTimeL.font = WJFont12;
        useTimeL.text = @"使用期限：2016.11.09-2016.12.09";
        
        statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageView.width - ALD(50), 0, ALD(50), ALD(50))];
        
        
//        singleSelectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(5), (bgImageView.height - ALD(14))/2, ALD(14), ALD(14))];
//        singleSelectImageView.hidden = YES;
        
        [bgImageView addSubview:amountL];
        [bgImageView addSubview:couponDes];
        [bgImageView addSubview:lineView];
        [bgImageView addSubview:nameL];
        [bgImageView addSubview:useTimeL];
        [bgImageView addSubview:statusImageView];
//        [bgImageView addSubview:singleSelectImageView];

        [self.contentView addSubview:bgImageView];


    }
    return self;
}

- (void)configDataWithCoupon:(WJCouponModel *)model
{
    amountL.text = [NSString stringWithFormat:@"¥%@",model.amount];
    couponDes.text = [NSString stringWithFormat:@"满%@元可用",model.couponDes];
    nameL.text = model.name;
    useTimeL.text = [NSString stringWithFormat:@"使用期限:%@-%@",model.startTime,model.validTime];
    
    
    if (model.couponCurrentStatus == CouponStatusNoUse) {
        bgImageView.image = [UIImage imageNamed:@"ticket_normal"];
        
        amountL.textColor = WJColorNavigationBar;
        couponDes.textColor = WJColorNavigationBar;
        nameL.textColor = WJColorNavigationBar;
        useTimeL.textColor = WJColorNavigationBar;

        
    } else {
        
        bgImageView.image = [UIImage imageNamed:@"ticket_outtime"];
        
        amountL.textColor = WJColorDardGray9;
        couponDes.textColor = WJColorDardGray9;
        nameL.textColor = WJColorDardGray9;
        useTimeL.textColor = WJColorDardGray9;
    }
    
    [self settingRightStatusImageView:model];
}

//设置cell右侧imageView
-(void)settingRightStatusImageView:(WJCouponModel *)model
{
    switch (model.couponCurrentStatus) {
            
        case CouponStatusNoUse:
            
            statusImageView.image = nil;
            statusImageView.hidden = YES;
            
            break;
            
        case CouponStatusAlreadyUsed:
            
            statusImageView.image = [UIImage imageNamed:@"ticketIsUsed"];
            
            break;
            
        case CouponStatusExpired:
            
            statusImageView.image = [UIImage imageNamed:@"ticketAlreadyOverdate"];
            
            break;
            
        default:
            statusImageView.image = nil;
            statusImageView.hidden = YES;
            break;
    }
    
}

//左侧单选框图片
-(void)changeCurrentCellActive
{
    singleSelectImageView.image = [UIImage imageNamed:@"toggle_button_selected"];
    singleSelectImageView.backgroundColor = [UIColor clearColor];
}

//-(void)changeCurrentCellInactive
//{
//    singleSelectImageView.image = [UIImage imageNamed:@"toggle_button_nor"];
//    singleSelectImageView.backgroundColor = [UIColor clearColor];
//}

////反转单选框选中状态
//-(CouponSingleSelectBoxStatus)changeCurrentCellInverse
//{
//    switch (self.singleSelectBoxStatus) {
//        case CouponBoxStatusSelect:
//            return CouponBoxStatusInactive;
//
//            break;
//            
//        case CouponBoxStatusInactive:
//            return CouponBoxStatusSelect;
//            
//            break;
//            
//        default:
//            return CouponBoxStatusInactive;
//            break;
//    }
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
