//
//  WJImageViewWithBK.m
//  HuPlus
//
//  Created by reborn on 17/4/1.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJImageViewWithBK.h"

@interface WJImageViewWithBK ()
@property(nonatomic,strong)UIImageView *bgImageView;

@end

@implementation WJImageViewWithBK

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
        self.bgImageView = imageView;
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"image"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgImageView.frame = self.bounds;
}

- (void)setBgImageView:(UIImageView *)bgImageView
{
    if (_bgImageView) {
        [_bgImageView removeFromSuperview];
        _bgImageView = nil;
    }
    
    _bgImageView = bgImageView;
    [self addSubview:_bgImageView];
    _bgImageView.contentMode = UIViewContentModeCenter;
    _bgImageView.backgroundColor = WJColorDefaultBackground;
    _bgImageView.image = BitmapCustomImage;
    _bgImageView.hidden = YES;
}

- (void)showBkImage
{
    _bgImageView.hidden = NO;
}

- (void)hideBkImage
{
    _bgImageView.hidden = YES;
}

#pragma mark -
#pragma mark KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"image"])
    {
        if (self.image) {
            [self hideBkImage];
        } else {
            [self showBkImage];
        }
    }
}

@end
