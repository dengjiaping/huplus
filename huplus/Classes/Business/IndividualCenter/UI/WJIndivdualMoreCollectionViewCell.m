//
//  WJIndivdualMoreCollectionViewCell.m
//  HuPlus
//
//  Created by reborn on 16/12/19.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJIndivdualMoreCollectionViewCell.h"

@interface WJIndivdualMoreCollectionViewCell ()
{
    UILabel *titleL;
    UIImageView *rigtArrowIV;
    UILabel *moreL;
}
@end

@implementation WJIndivdualMoreCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WJColorViewBg;
        self.contentView.layer.borderColor = WJColorSeparatorLine.CGColor;
        self.contentView.layer.borderWidth = 0.5f;
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), 0, ALD(100), frame.size.height)];
        titleL.font = WJFont14;
        titleL.text = @"我的订单";
        titleL.textAlignment = NSTextAlignmentLeft;
        titleL.textColor = WJColorNavigationBar;
        
        UIImage *image = [UIImage imageNamed:@"icon_arrow_right"];
        rigtArrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-image.size.width-ALD(10), (frame.size.height - image.size.height)/2, image.size.width, image.size.height)];
        rigtArrowIV.image = image;
        
        moreL = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-ALD(100)-ALD(15), 0, ALD(100), frame.size.height)];
        moreL.font = WJFont14;
        moreL.text = @"查看全部订单";
        moreL.textColor = WJColorLightGray;
        
        UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [moreButton addTarget:self action:@selector(clickAllTypeOrder) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:titleL];
        [self addSubview:rigtArrowIV];
        [self addSubview:moreL];
        [self addSubview:moreButton];

    }
    return self;
}

-(void)clickAllTypeOrder
{
    if ([self.delegate respondsToSelector:@selector(allTypeOrderCollectionViewCellWithClick)]) {
        [self.delegate allTypeOrderCollectionViewCellWithClick];
    }
}

@end
