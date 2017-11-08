//
//  WJChooseChargeValueView.m
//  HuPlus
//
//  Created by reborn on 16/12/30.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJChooseChargeValueView.h"
#import "WJChargeValueModel.h"
#import "WJChooseChargeViewCell.h"
@interface WJChooseChargeValueView ()
{
    UIView   *bgWhiteView;
    UILabel  *balanceL;
    UIView   *imageListView;
    UIView   *lineView;
    
    UILabel  *desL;
    
    NSArray  *listArray;
    NSInteger selectNum;
}
@end

@implementation WJChooseChargeValueView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        listArray = [NSArray array];
        selectNum = listArray.count;


        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        
        bgWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        bgWhiteView.backgroundColor = WJColorWhite;
        
        
        balanceL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(10), ALD(200), ALD(30))];
        balanceL.font = WJFont18;
        balanceL.text = @"余额：¥8880.00";
        balanceL.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(ALD(12),balanceL.bottom + ALD(15), kScreenWidth - ALD(24), 1)];
        lineView.backgroundColor = WJColorSeparatorLine;
        
        desL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), lineView.bottom + ALD(10), kScreenWidth, ALD(20))];
        desL.text = @"请选择充值的金额";
        desL.textColor = WJColorNavigationBar;
        desL.font = WJFont14;
        
        
        
        imageListView = [[UIView alloc] init];
        
        [bgWhiteView addSubview:balanceL];
        [bgWhiteView addSubview:lineView];
        [bgWhiteView addSubview:desL];
        [bgWhiteView addSubview:imageListView];
        [self addSubview:bgWhiteView];
        
    }
    return self;
}

- (void)refreshWithDictionaryWithListFaceValue:(NSArray *)cardArray
{
    CGFloat totalHeight = ALD(70) * ([cardArray count]/3 + ((([cardArray count]%3) == 0)? 0 : 1));
    
    listArray = cardArray;
    
    [imageListView setFrame:CGRectMake(0, desL.bottom + ALD(10), kScreenWidth, totalHeight)];
    
    for (UIView * view in [imageListView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < [cardArray count]; i++) {
        
        WJChargeValueModel * model = [cardArray objectAtIndex:i];
        
        WJChooseChargeViewCell * cell = [[WJChooseChargeViewCell alloc] initWithPoint:CGPointMake(ALD(12) + i%3 * (ALD(121)),  i/3 * ALD(70)) value:model.faceValue des:model.sellValue];
        [imageListView addSubview:cell];
        cell.tag = 10000 + i;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapAction:)];
        [cell addGestureRecognizer:tap];
    }
    
    [bgWhiteView setFrame:CGRectMake(0, 0, kScreenWidth,  totalHeight + ALD(98))];

    
    [self selectCellIndex];
}

- (void)exchangeButtonAction
{
    WJChargeValueModel * model = [listArray objectAtIndex:selectNum];
    if ([self.delegate respondsToSelector:@selector(selectChargeModel:)]) {
        [self.delegate selectChargeModel:model];
    }
}

- (void)selectCellIndex
{
    for (UIView * view in [imageListView subviews]) {
        
        if ([view isKindOfClass:[WJChooseChargeViewCell class]]) {
            WJChooseChargeViewCell * cell = (WJChooseChargeViewCell *)view;
            if ((cell.tag - 10000) == selectNum)
            {
                cell.selected = YES;
                
            } else {
                cell.selected = NO;
            }
        }
    }
}


- (void)cellTapAction:(UITapGestureRecognizer *)tap
{
    selectNum = tap.view.tag - 10000;
    [self selectCellIndex];
}

@end
