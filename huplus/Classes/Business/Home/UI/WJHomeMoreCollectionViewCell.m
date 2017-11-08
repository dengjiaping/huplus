//
//  WJHomeMoreCollectionViewCell.m
//  HuPlus
//
//  Created by reborn on 16/12/19.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJHomeMoreCollectionViewCell.h"

@interface WJHomeMoreCollectionViewCell ()
{
    UILabel     *titleL;
    UIImageView *rigtImageView;
    UILabel     *moreL;
}

@end

@implementation WJHomeMoreCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = WJColorWhite;
        
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 10)];
        spaceView.backgroundColor = WJColorViewBg;
        [self addSubview:spaceView];
        
        
        titleL = [[UILabel alloc] init];
        titleL.frame = CGRectMake((frame.size.width - ALD(100))/2, 0, ALD(100), frame.size.height);
        titleL.font = WJFont14;
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor = WJColorNavigationBar;
        [self.contentView addSubview:titleL];

        
        UIImage *image = [UIImage imageNamed:@"icon_arrow_right"];
        rigtImageView = [[UIImageView alloc] init];
        rigtImageView.frame = CGRectMake(frame.size.width - image.size.width - ALD(10), (titleL.height - image.size.height)/2, image.size.width, image.size.height);
        rigtImageView.image = image;
        [self.contentView addSubview:rigtImageView];

        
        moreL = [[UILabel alloc] init];
        moreL.frame = CGRectMake(frame.size.width-ALD(30)-ALD(15), 0, ALD(30), frame.size.height);
        moreL.font = WJFont12;
        moreL.text = @"更多";
        moreL.textColor = WJColorViewNotEditable;
        [self.contentView addSubview:moreL];

        
        UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, titleL.height)];
        [moreButton addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:moreButton];
        
        UIView *bottomLine = [[UIView alloc]initForAutoLayout];
        bottomLine.backgroundColor = WJColorViewBg;
        [self.contentView addSubview:bottomLine];
        [self.contentView addConstraints:[bottomLine constraintsSize:CGSizeMake(kScreenWidth - 30, 0.5)]];
        [self.contentView addConstraints:[bottomLine constraintsLeftInContainer:15]];
        [self.contentView addConstraints:[bottomLine constraintsAssignBottom]];

        if (frame.size.height == ALD(50)) {
            titleL.frame = CGRectMake((frame.size.width - ALD(100))/2, 10, ALD(100), frame.size.height - 10);
            rigtImageView.frame = CGRectMake(frame.size.width - image.size.width - ALD(10), (frame.size.height -10 - image.size.height)/2 + 10, image.size.width, image.size.height);
            moreL.frame = CGRectMake(frame.size.width-ALD(30)-ALD(15), 10, ALD(30), frame.size.height - 10);

        }

    }
    return self;
}

-(void)clickMore
{
    if ([self.delegate respondsToSelector:@selector(moreCollectionViewCellWithClickMore:section:)]) {
        [self.delegate moreCollectionViewCellWithClickMore:self section:self.section];
    }
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    titleL.text = _title;
}

@end
