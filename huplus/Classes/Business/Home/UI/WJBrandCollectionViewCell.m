//
//  WJBrandCollectionViewCell.m
//  HuPlus
//
//  Created by reborn on 17/1/12.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJBrandCollectionViewCell.h"
#import "WJBrandModel.h"
#import <UIImageView+WebCache.h>
@interface WJBrandCollectionViewCell ()
{
    UIImageView *imageView;
    UILabel     *titleL;
}
@end

@implementation WJBrandCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.layer.borderWidth = 0.5f;
        self.contentView.layer.borderColor = WJColorSeparatorLine.CGColor;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - BitmapBrandImage.size.width)/2, (frame.size.height - BitmapBrandImage.size.height)/2 - ALD(10), BitmapBrandImage.size.width, BitmapBrandImage.size.height)];
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,imageView.bottom + ALD(10), frame.size.width, ALD(20))];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor = WJColorNavigationBar;
        titleL.font = WJFont14;
        [self addSubview:titleL];
        
    }
    return self;
}

-(void)configDataWithBrandModel:(WJBrandModel *)model
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:BitmapBrandImage];
    titleL.text = model.brandName;
}

@end
