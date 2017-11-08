//
//  WJPaymentView.h
//  HuPlus
//
//  Created by reborn on 16/12/26.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJPaymentViewDelegate <NSObject>

-(void)refreshPayCodeButtonClick;

@end

@interface WJPaymentView : UIView
@property(nonatomic,weak) id<WJPaymentViewDelegate>delegate;
@property(nonatomic,strong)UIImageView *barCodeImageView; //条形码
@property(nonatomic,strong)UILabel     *barCodeLabel;     //条形码数字
@property(nonatomic,strong)UIImageView *qrCodeImageView;  //二维码

@end
