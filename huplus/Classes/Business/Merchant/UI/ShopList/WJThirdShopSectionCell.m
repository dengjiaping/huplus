//
//  WJThirdShopSectionCell.m
//  HuPlus
//
//  Created by reborn on 17/2/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJThirdShopSectionCell.h"
#import "WJSegmentedView.h"
@interface WJThirdShopSectionCell ()<WJSegmentedViewDelegate>
{
    WJSegmentedView *segmentedView;
}

@end

@implementation WJThirdShopSectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WJColorViewBg;
        
        segmentedView  = [[WJSegmentedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(40)) items:@[@"推荐商品",@"热销商品",@"全部商品"]];
        [segmentedView setBottomLineView:YES];
        segmentedView.delegate = self;
        [self addSubview:segmentedView];

    }
    return self;
}

#pragma mark - WJSegmentedViewDelegate
-(void)segmentedView:(WJSegmentedView *)segmentedView buttonClick:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            if ([self.delegate respondsToSelector:@selector(shopSectionView:clickIndex:)]) {
                [self.delegate shopSectionView:self clickIndex:0];
            }
        }
            break;
            
            
        case 1:
        {
            if ([self.delegate respondsToSelector:@selector(shopSectionView:clickIndex:)]) {
                [self.delegate shopSectionView:self clickIndex:1];
            }
        }

            break;
            
        case 2:
        {
            if ([self.delegate respondsToSelector:@selector(shopSectionView:clickIndex:)]) {
                [self.delegate shopSectionView:self clickIndex:2];
            }
        }

            break;
            
        default:
            break;
    }
}

@end
