//
//  WJChooseCreditsValueView.m
//  HuPlus
//
//  Created by reborn on 16/12/23.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJChooseCreditsValueView.h"
#import "WJCreditsValueModel.h"
#import "WJChooseViewCell.h"
@interface WJChooseCreditsValueView ()
{
    UIView   *bgWhiteView;
    UILabel  *creditsBalanceL;
    UIView   *imageListView;
    UIButton *closeButton;
    UIButton *exchangeButton;
    
    NSArray  *listArray;

    NSInteger selectNum;
}

@end

@implementation WJChooseCreditsValueView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        selectNum = 0;
        listArray = [NSArray array];
        
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        
        bgWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        bgWhiteView.backgroundColor = WJColorWhite;

        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.backgroundColor = [UIColor redColor];
        [closeButton setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
        [closeButton setImage:[UIImage imageNamed:@"closeButton_press"] forState:UIControlStateSelected];
        [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        creditsBalanceL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(10), ALD(200), ALD(30))];
        creditsBalanceL.font = WJFont14;
        creditsBalanceL.text = @"积分余额:7480";
        creditsBalanceL.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
        
        exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [exchangeButton setTitle:@"立即兑换" forState:UIControlStateNormal];
        exchangeButton.backgroundColor = WJColorMainRed;
        [exchangeButton addTarget:self action:@selector(exchangeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        imageListView = [[UIView alloc] init];

        
        [bgWhiteView addSubview:closeButton];
        [bgWhiteView addSubview:creditsBalanceL];
        [bgWhiteView addSubview:imageListView];
        [bgWhiteView addSubview:exchangeButton];
        
        [self addSubview:bgWhiteView];
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
        [self addGestureRecognizer:tap];

    }
    return self;
}

- (void)refreshWithDictionaryWithListFaceValue:(NSArray *)cardArray
{
    CGFloat totalHeight = ALD(70) * ([cardArray count]/3 + ((([cardArray count]%3) == 0)? 0 : 1));
    
    listArray = cardArray;
    
    [closeButton setFrame:CGRectMake(kScreenWidth - ALD(32), self.y + ALD(12), ALD(20), ALD(20))];
    [imageListView setFrame:CGRectMake(0, creditsBalanceL.bottom, kScreenWidth, totalHeight)];

    for (UIView * view in [imageListView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < [cardArray count]; i++) {
        
        WJCreditsValueModel * model = [cardArray objectAtIndex:i];
        
        WJChooseViewCell * cell = [[WJChooseViewCell alloc] initWithPoint:CGPointMake(ALD(12) + i%3 * (ALD(121)),  i/3 * ALD(70)) value:model.faceValue des:model.sellValue];
        [imageListView addSubview:cell];
        cell.tag = 10000 + i;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapAction:)];
        [cell addGestureRecognizer:tap];
    }

    [exchangeButton setFrame:CGRectMake(ALD(10), CGRectGetMaxY(imageListView.frame) + ALD(15) , kScreenWidth - ALD(20), ALD(48))];
    
    [bgWhiteView setFrame:CGRectMake(0, self.height - ALD(201) - totalHeight, kScreenWidth, ALD(101) + ALD(52) + totalHeight + ALD(48))];
    
    [self selectCellIndex];
}

- (void)closeAction
{
    self.hidden = YES;
}

- (void)exchangeButtonAction
{
    WJCreditsValueModel * model = [listArray objectAtIndex:selectNum];
    if ([self.delegate respondsToSelector:@selector(selectModel:)]) {
        [self.delegate selectModel:model];
    }
}

- (void)selectCellIndex
{
    for (UIView * view in [imageListView subviews]) {
        
        if ([view isKindOfClass:[WJChooseViewCell class]]) {
            WJChooseViewCell * cell = (WJChooseViewCell *)view;
            if ((cell.tag - 10000) == selectNum)
            {
                cell.selected = YES;
//                WJCreditsValueModel * model = [listArray objectAtIndex:selectNum];
                
            } else {
                cell.selected = NO;
            }
        }
    }
}


- (void)cellTapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"%@",tap.view);
    selectNum = tap.view.tag - 10000;
    [self selectCellIndex];
    
}
@end
