//
//  WJExpressView.m
//  HuPlus
//
//  Created by reborn on 17/3/24.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJExpressView.h"

@interface WJExpressView ()<UITextFieldDelegate>
{
    UILabel *expressL;
    UIImageView *arrowIV;
}

@end
@implementation WJExpressView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WJColorWhite;
        
        expressL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(10), kScreenWidth, ALD(20))];
        expressL.font = WJFont14;
        expressL.textColor = WJColorDardGray9;
        [self addSubview:expressL];
        
        _expressTF = [[UITextField alloc] initWithFrame:CGRectMake(ALD(12), expressL.bottom + ALD(10), kScreenWidth - ALD(24), ALD(28))];
        _expressTF.backgroundColor = WJColorViewBg2;
        _expressTF.delegate = self;
        _expressTF.font = WJFont14;
        _expressTF.textColor = WJColorNavigationBar;
        _expressTF.borderStyle=UITextBorderStyleRoundedRect;
        _expressTF.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_expressTF];
        
        UIImage *arrowImage = [UIImage imageNamed:@"mail_arrow_down"];
        arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(_expressTF.width - ALD(10) - arrowImage.size.width,(_expressTF.height - arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height)];
        arrowIV.image = arrowImage;
        arrowIV.hidden = YES;
        [_expressTF addSubview:arrowIV];
        
    }
    return self;
}

-(void)configDataWithTitle:(NSString *)title placeholder:(NSString *)placeholder isShowArrowIV:(BOOL)isShowArrowIV
{
    expressL.text = title;
    _expressTF.placeholder = placeholder;
    arrowIV.hidden = !isShowArrowIV;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(endEditExpressView:)]) {
        
        [self.delegate endEditExpressView:self.expressTF];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startEditExpressView:)]) {
        
        [self.delegate startEditExpressView:self.expressTF];
    }
}

@end
