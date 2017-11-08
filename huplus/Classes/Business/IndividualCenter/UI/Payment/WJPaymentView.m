//
//  WJPaymentView.m
//  HuPlus
//
//  Created by reborn on 16/12/26.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJPaymentView.h"

@interface WJPaymentView ()
{
    UIView      *payBgView;     //灰色背景
    UIView      *whiteBgView;   //白色背景
    UIView      *barCodeBgView; //放大动画白色背景
    
    UIView      *testView;      //条形码全部区域
    
    UIImageView *refImageView; //刷新二维码图片
    UIButton    *refPayCodeBtn;//刷新付款码按钮
}

@end

@implementation WJPaymentView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        payBgView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-ALD(351))/2,ALD(60),ALD(351),ALD(395))];
        payBgView.backgroundColor = WJColorViewBg;
        payBgView.layer.cornerRadius = 8;
        payBgView.layer.shadowOpacity = 0.2;
        payBgView.layer.shadowOffset = CGSizeMake(0.1, 1);
        payBgView.layer.shadowRadius = 2;
        
        
        whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,payBgView.width,ALD(351))];
        whiteBgView.backgroundColor = [UIColor whiteColor];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:whiteBgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8,8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = whiteBgView.bounds;
        maskLayer.path = maskPath.CGPath;
        whiteBgView.layer.mask = maskLayer;
        
        
        refImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(133.5), whiteBgView.bottom+ALD(15),ALD(13), ALD(12))];
        refImageView.image = [UIImage imageNamed:@"cardpackage_btn_refresh"];
        refImageView.backgroundColor = [UIColor orangeColor];
        
        
        refPayCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        refPayCodeBtn.frame = CGRectMake(refImageView.right+ALD(5),whiteBgView.bottom+ALD(13), ALD(90), ALD(16));
        [refPayCodeBtn setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [refPayCodeBtn setTitle:@"刷新付款码" forState:UIControlStateNormal];
        refPayCodeBtn.titleLabel.font = WJFont14;
        refPayCodeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [refPayCodeBtn addTarget:self action:@selector(refreshPayCodeClick) forControlEvents:UIControlEventTouchUpInside];
        
        
//        barCodeBgView = [[UIView alloc] initWithFrame:CGRectMake(- (payBgView.width - ALD(347))/2,0, payBgView.width, frame.size.height + ALD(13))];
        barCodeBgView = [[UIView alloc] initWithFrame:CGRectMake(0,0, payBgView.width, frame.size.height)];

        barCodeBgView.backgroundColor = [UIColor whiteColor];
        barCodeBgView.tag = 10001;
        barCodeBgView.alpha = 0;
        barCodeBgView.userInteractionEnabled = YES;
        
        
        testView = [[UIImageView alloc] initWithFrame:CGRectMake((payBgView.width-ALD(267.5))/2, ALD(30), ALD(267.5), ALD(72+16))];
        testView.userInteractionEnabled = YES;
        testView.tag = 10001;
        UITapGestureRecognizer *barCodeGes  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
        [testView addGestureRecognizer:barCodeGes];
        
        //条形码
        _barCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, ALD(267.5), ALD(62))];
        _barCodeImageView.tag = 10001;
        _barCodeImageView.userInteractionEnabled = YES;
        _barCodeImageView.backgroundColor = [UIColor cyanColor];
        
        //条形码数字
        _barCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_barCodeImageView.bottom+ALD(10), ALD(267.5), ALD(16))];
        _barCodeLabel.font = WJFont14;
        _barCodeLabel.text = @"13431325d54325351353554";
        _barCodeLabel.textAlignment =  NSTextAlignmentCenter;
        
        //二维码
        _qrCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((payBgView.width-ALD(170.5))/2, testView.bottom+ALD(34), ALD(170.5), ALD(168))];
        _qrCodeImageView.userInteractionEnabled = YES;
        _qrCodeImageView.tag = 10002;
        _qrCodeImageView.backgroundColor =[UIColor orangeColor];
        UITapGestureRecognizer *ges  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
        [_qrCodeImageView addGestureRecognizer:ges];
    
        
        [payBgView addSubview:whiteBgView];
        [payBgView addSubview:refImageView];
        [payBgView addSubview:refPayCodeBtn];
        [payBgView addSubview:barCodeBgView];
        [payBgView addSubview:testView];
        [payBgView addSubview:_qrCodeImageView];
        
        [testView addSubview:_barCodeImageView];
        [testView addSubview:_barCodeLabel];
        
        [self addSubview:payBgView];
        
    }
    return self;
}

#pragma mark - 刷新付款码点击事件
-(void)refreshPayCodeClick
{
    if ([self.delegate respondsToSelector:@selector(refreshPayCodeButtonClick)]) {
        [self.delegate refreshPayCodeButtonClick];
    }
}

#pragma mark - 二维码条形码放大事件
-(void)magnifyImage:(UITapGestureRecognizer *)gesture
{
    [self showImage:(UIImageView *)[gesture view]];//调用方法
}

#pragma mark - 付款码放大动画
-(void)showImage:(UIImageView *)avatarImageView {
    UITapGestureRecognizer
    *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    
    [barCodeBgView  addGestureRecognizer: tap];
    barCodeBgView.tag = avatarImageView.tag;
    
    if(avatarImageView.tag == 10001)
    {
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:7 initialSpringVelocity:4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _qrCodeImageView.alpha = 0;
            barCodeBgView.alpha = 1;
            testView.transform = CGAffineTransformRotate(testView.transform, M_PI_2);
            testView.frame = CGRectMake(ALD(112), ALD(110-64), ALD(150), ALD(447));
            _barCodeImageView.frame = CGRectMake(0, 0, ALD(447), ALD(102));
            _barCodeLabel.frame = CGRectMake(ALD(47), ALD(142), ALD(447)-ALD(80), ALD(18));
            _barCodeLabel.transform = CGAffineTransformMake(1.1, 0, 0, 1.1, 0, 0);
            
            _barCodeLabel.font = WJFont16;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:_barCodeLabel.text attributes:@{NSKernAttributeName : @(4.5f)}];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _barCodeLabel.text.length)];
            _barCodeLabel.attributedText = attributedString;
            _barCodeLabel.textAlignment = NSTextAlignmentCenter;
            
            payBgView.layer.shadowOpacity = 0;
            
            self.backgroundColor = [UIColor whiteColor];
            
        } completion:^(BOOL finished) {
            UITapGestureRecognizer
            *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
            [testView
             addGestureRecognizer: tap];
        }];
        
    } else {
        [UIView animateWithDuration:.35 animations:^{
            testView.alpha = 0;
            barCodeBgView.alpha = 1;
            payBgView.layer.shadowOpacity = 0;
            
            self.backgroundColor = [UIColor whiteColor];
            avatarImageView.frame = CGRectMake((payBgView.width-ALD(243))/2, ALD(212-64), ALD(243), ALD(243));;
            
        } completion:^(BOOL finished) {
            UITapGestureRecognizer
            *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
            [avatarImageView
             addGestureRecognizer: tap];
        }];
    }
}

#pragma mark - 付款码隐藏动画
-(void)hideImage:(UITapGestureRecognizer*)tap {
    
    if(barCodeBgView.tag == 10001)
    {
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:7 initialSpringVelocity:4 options:UIViewAnimationOptionCurveEaseInOut animations:^{

            _qrCodeImageView.alpha = 1;
            barCodeBgView.alpha = 0;
            testView.transform = CGAffineTransformRotate(testView.transform, -M_PI_2);
            testView.frame = CGRectMake((payBgView.width-ALD(267.5))/2, ALD(30), ALD(267.5), ALD(72+16));
            _barCodeImageView.frame = CGRectMake(0,0, ALD(267.5), ALD(60));
            _barCodeLabel.frame = CGRectMake(ALD(0), ALD(72), ALD(267.5), ALD(16));
            _barCodeLabel.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
            
            _barCodeLabel.font = WJFont14;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:_barCodeLabel.text attributes:@{NSKernAttributeName : @(2.0f)}];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _barCodeLabel.text.length)];
            _barCodeLabel.attributedText = attributedString;
            _barCodeLabel.textAlignment = NSTextAlignmentCenter;
            payBgView.layer.shadowOpacity = 0.2;
            self.backgroundColor = WJColorViewBg;
        } completion:^(BOOL finished) {
            [barCodeBgView removeGestureRecognizer:tap];
            UITapGestureRecognizer *barCodeGes  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
            [testView addGestureRecognizer:barCodeGes];
        }];
        
    } else {
        [UIView animateWithDuration:.35 animations:^{

            testView.alpha = 1;
            barCodeBgView.alpha = 0;
            payBgView.layer.shadowOpacity = 0.2;
            self.backgroundColor = WJColorViewBg;
            _qrCodeImageView.frame = CGRectMake((payBgView.width-ALD(170.5))/2, testView.bottom+ALD(34), ALD(170.5), ALD(168));
            
        } completion:^(BOOL finished) {
            [barCodeBgView removeGestureRecognizer:tap];
            UITapGestureRecognizer *barCodeGes  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
            [_qrCodeImageView addGestureRecognizer:barCodeGes];
        }];
        
    }
}



@end
