//
//  WJPhotoView.m
//  HuPlus
//
//  Created by reborn on 17/1/4.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJPhotoView.h"

@interface WJPhotoView ()
{
    UIButton    *photoAlbumButton;
    UIButton    *takePhotoButton;
    UIImageView *albumImageView;
    UIImageView *takePhotoImageView;
}
@end

@implementation WJPhotoView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        albumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), ALD(10), ALD(20), ALD(20))];
//        albumImageView.backgroundColor = [UIColor redColor];
        
        photoAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        photoAlbumButton.frame = CGRectMake((ALD(200) - ALD(80))/2, ALD(15), ALD(80), ALD(30));
        [photoAlbumButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
        [photoAlbumButton setTitle:@"相册" forState:UIControlStateNormal];
        photoAlbumButton.titleLabel.font = WJFont14;
        photoAlbumButton.backgroundColor = WJColorNavigationBar;
        [photoAlbumButton addTarget:self action:@selector(photoAlbumButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        
//        takePhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), albumImageView.bottom +ALD(20), ALD(20), ALD(20))];
//        takePhotoImageView.backgroundColor = [UIColor redColor];
        
        takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        takePhotoButton.frame = CGRectMake((ALD(200) - ALD(80))/2, photoAlbumButton.bottom  +ALD(10), ALD(80), ALD(30));
        takePhotoButton.backgroundColor = WJColorNavigationBar;
        [takePhotoButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
        [takePhotoButton setTitle:@"拍照" forState:UIControlStateNormal];
        takePhotoButton.titleLabel.font = WJFont14;
        [takePhotoButton addTarget:self action:@selector(takePhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
        
//        [self addSubview:albumImageView];
        [self addSubview:photoAlbumButton];
//        [self addSubview:takePhotoImageView];
        [self addSubview:takePhotoButton];

    }
    return self;
}

#pragma mark - Action
-(void)photoAlbumButtonClick
{
    if ([self.delegate respondsToSelector:@selector(photoViewClickAlbum)]) {
        [self.delegate photoViewClickAlbum];
    }
}

-(void)takePhotoButtonClick
{
    if ([self.delegate respondsToSelector:@selector(photoViewClickTakePhoto)]) {
        [self.delegate photoViewClickTakePhoto];
    }
}



@end
