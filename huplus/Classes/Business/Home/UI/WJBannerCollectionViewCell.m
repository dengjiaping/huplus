//
//  WJBannerCollectionViewCell.m
//  HuPlus
//
//  Created by reborn on 16/12/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJBannerCollectionViewCell.h"

@implementation WJBannerCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
    }
    return self;
}
@end
