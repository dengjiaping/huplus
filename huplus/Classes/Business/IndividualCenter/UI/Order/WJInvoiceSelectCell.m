//
//  WJInvoiceSelectCell.m
//  HuPlus
//
//  Created by reborn on 17/2/13.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJInvoiceSelectCell.h"

@interface WJInvoiceSelectCell ()
{
    UILabel *descriptionL;
//    UIButton *makingInvoiceButton;
//    UIButton *noInvoiceButton;
}

@end

@implementation WJInvoiceSelectCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        descriptionL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(5), kScreenWidth, ALD(20))];
        descriptionL.text = @"是否开发票";
        descriptionL.textColor = WJColorNavigationBar;
        descriptionL.font = WJFont14;
        [self addSubview:descriptionL];
        
        _noInvoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _noInvoiceButton.frame = CGRectMake(ALD(12), descriptionL.bottom + ALD(10), ALD(90), ALD(30));
        [_noInvoiceButton setTitle:@"不开发票" forState:UIControlStateNormal];
//        [noInvoiceButton setTitleColor:WJColorMainRed forState:UIControlStateNormal];
        [_noInvoiceButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];

        _noInvoiceButton.layer.cornerRadius = 4;
//        noInvoiceButton.layer.borderColor = WJColorMainRed.CGColor;
        _noInvoiceButton.layer.borderColor = WJColorLightGray.CGColor;

        _noInvoiceButton.layer.borderWidth = 0.5;
        _noInvoiceButton.titleLabel.font = WJFont14;
        [_noInvoiceButton addTarget:self action:@selector(noInvoiceButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_noInvoiceButton];
        
        _makingInvoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _makingInvoiceButton.frame = CGRectMake(_noInvoiceButton.right + ALD(10), descriptionL.bottom + ALD(10), ALD(90), ALD(30));
        [_makingInvoiceButton setTitle:@"开发票" forState:UIControlStateNormal];
        [_makingInvoiceButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        _makingInvoiceButton.layer.cornerRadius = 4;
        _makingInvoiceButton.layer.borderColor = WJColorLightGray.CGColor;
        _makingInvoiceButton.layer.borderWidth = 0.5;
        _makingInvoiceButton.titleLabel.font = WJFont14;
        [_makingInvoiceButton addTarget:self action:@selector(makingInvoiceButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_makingInvoiceButton];
        
    }
    
    return self;
}

#pragma mark - Action
-(void)noInvoiceButtonAction
{
//    [self changeAllButtonBorderColor];
    
//    noInvoiceButton.layer.borderColor = WJColorMainRed.CGColor;
//    [noInvoiceButton setTitleColor:WJColorMainRed forState:UIControlStateNormal];
//    self.noInvoiceBlock();
    
    if ([self.delegate respondsToSelector:@selector(clickNoInvoiceButton:)]) {
        [self.delegate clickNoInvoiceButton:self];
    }

}

-(void)makingInvoiceButtonAction
{
//    [self changeAllButtonBorderColor];
    
//    makingInvoiceButton.layer.borderColor = WJColorMainRed.CGColor;
//    [makingInvoiceButton setTitleColor:WJColorMainRed forState:UIControlStateNormal];
//    self.makingInvoiceBlock();
    
    if ([self.delegate respondsToSelector:@selector(clickMakingInvoiceButton:)]) {
        [self.delegate clickMakingInvoiceButton:self];
    }

}

-(void)changeAllButtonBorderColor
{
//    noInvoiceButton.layer.borderColor = WJColorLightGray.CGColor;
//    [noInvoiceButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
//
//    makingInvoiceButton.layer.borderColor = WJColorLightGray.CGColor;
//    [makingInvoiceButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];

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
