//
//  WJIndivdualCollectionViewCell.m
//  HuPlus
//
//  Created by reborn on 16/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJIndivdualCollectionViewCell.h"

@interface WJIndivdualCollectionViewCell ()
{
    UIImageView *imageView;
    UILabel     *titleL;
    UIImageView *rightArrowIV;
}
@end

@implementation WJIndivdualCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.layer.borderWidth = 0.5f;
        self.contentView.layer.borderColor = WJColorSeparatorLine.CGColor;
        
        UIImage *image = [UIImage imageNamed:@"myShopCart"];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), (ALD(44) - image.size.height)/2, image.size.width, image.size.height)];
        imageView.backgroundColor = [UIColor clearColor];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + ALD(10), (ALD(44) - ALD(20))/2, frame.size.width, ALD(20))];
        titleL.textAlignment = NSTextAlignmentLeft;
        titleL.textColor = WJColorNavigationBar;
        titleL.font = WJFont14;
        
        UIImage *arrawImage = [UIImage imageNamed:@"icon_arrow_right"];
        rightArrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - arrawImage.size.width, (ALD(44) - arrawImage.size.height)/2, arrawImage.size.width, arrawImage.size.height)];
        rightArrowIV.image = [UIImage imageNamed:@"icon_arrow_right"];
        
        _countL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(12) - arrawImage.size.width - ALD(5) - ALD(30), (ALD(44) - ALD(10))/2, ALD(30), ALD(10))];
        _countL.textColor = WJColorMainRed;
        _countL.font = WJFont12;
        _countL.textAlignment = NSTextAlignmentRight;
        _countL.hidden = YES;
        
        
        [self addSubview:imageView];
        [self addSubview:titleL];
        [self addSubview:rightArrowIV];
        [self addSubview:_countL];
    }
    return self;
}

-(void)configDataWithIcon:(NSString *)icon Title:(NSString *)title countString:(NSString *)count
{
    imageView.image = [UIImage imageNamed:icon];
    titleL.text = title;
    if ([count integerValue] > 0) {
        
        _countL.hidden = NO;
        _countL.text = count;

    } else {
        
        _countL.hidden = YES;

    }
}


@end
