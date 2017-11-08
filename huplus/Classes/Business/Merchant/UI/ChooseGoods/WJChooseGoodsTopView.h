//
//  WJChooseGoodsBGView.h
//  HuPlus
//
//  Created by XT Xiong on 2017/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJProductDetailModel.h"
@interface WJChooseGoodsTopView : UIView

@property(nonatomic,strong)UIButton         *backButton;
@property(nonatomic,strong)UIImageView      *imageView;
@property(nonatomic,strong)UILabel          *titleLabel;
@property(nonatomic,strong)UILabel          *priceLabel;
@property(nonatomic,strong)UILabel          *originalPriceLabel;
@property(nonatomic,strong)UILabel          *stockLabel;

-(void)configChooseViewWithModel:(WJProductDetailModel *)model;


@end
