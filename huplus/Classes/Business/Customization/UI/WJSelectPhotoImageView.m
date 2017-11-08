//
//  WJSelectPhotoImageView.m
//  HuPlus
//
//  Created by XT Xiong on 2017/2/26.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJSelectPhotoImageView.h"

@implementation WJSelectPhotoImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView * bgIView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        bgIView.image = [UIImage imageNamed:@"camera_background"];
        [self addSubview:bgIView];
        
        self.faceIV = [[UIImageView alloc]initForAutoLayout];
        self.faceIV.image = [UIImage imageNamed:@"camera_contour_modal"];
        [self addSubview:self.faceIV];
        [self addConstraints:[self.faceIV constraintsTopInContainer:221]];
        [self addConstraint:[self.faceIV constraintCenterXInContainer]];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_closeButton setImage:[UIImage imageNamed:@"camera_close_icon"] forState:UIControlStateNormal];
        [self addSubview:_closeButton];
        [self addConstraints:[_closeButton constraintsTopInContainer:20]];
        [self addConstraints:[_closeButton constraintsLeftInContainer:16]];
        
        _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _quitButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_quitButton setImage:[UIImage imageNamed:@"camera_cancel"] forState:UIControlStateNormal];
        [self addSubview:_quitButton];
        [self addConstraints:[_quitButton constraintsBottomInContainer:57]];
        [self addConstraints:[_quitButton constraintsLeftInContainer:93]];
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_sureButton setImage:[UIImage imageNamed:@"camera_confirm"] forState:UIControlStateNormal];
        [self addSubview:_sureButton];
        [self addConstraints:[_sureButton constraintsBottomInContainer:57]];
        [self addConstraints:[_sureButton constraintsRightInContainer:93]];
        
    }
    return self;
}

@end
