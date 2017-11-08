//
//  WJCustomOverlayView.m
//  HuPlus
//
//  Created by XT Xiong on 2017/2/22.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJCustomOverlayView.h"

@implementation WJCustomOverlayView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView * bgIView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        bgIView.image = [UIImage imageNamed:@"camera_background"];
        [self addSubview:bgIView];
        
        UIImageView * faceIV = [[UIImageView alloc]initForAutoLayout];
        faceIV.image = [UIImage imageNamed:@"camera_contour_modal"];
        [self addSubview:faceIV];
        [self addConstraints:[faceIV constraintsTopInContainer:221]];
        [self addConstraint:[faceIV constraintCenterXInContainer]];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_closeButton setImage:[UIImage imageNamed:@"camera_close_icon"] forState:UIControlStateNormal];
        [self addSubview:_closeButton];
        [self addConstraints:[_closeButton constraintsTopInContainer:20]];
        [self addConstraints:[_closeButton constraintsLeftInContainer:16]];
        
        _shootButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shootButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_shootButton setImage:[UIImage imageNamed:@"camera_take_photo"] forState:UIControlStateNormal];
        [self addSubview:_shootButton];
        [self addConstraints:[_shootButton constraintsBottomInContainer:57]];
        [self addConstraint:[_shootButton constraintCenterXInContainer]];

        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_switchButton setImage:[UIImage imageNamed:@"camera_switch_icon"] forState:UIControlStateNormal];
        [self addSubview:_switchButton];
        [self addConstraints:[_switchButton constraintsBottomInContainer:57]];
        [self addConstraints:[_switchButton constraintsLeftInContainer:43]];
//        [self addConstraints:[_switchButton constraintsRight:30 FromView:_shootButton]];
        
        _libraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _libraryButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_libraryButton setImage:[UIImage imageNamed:@"camera_pick_photo"] forState:UIControlStateNormal];
        [self addSubview:_libraryButton];
        [self addConstraints:[_libraryButton constraintsBottomInContainer:57]];
        [self addConstraints:[_libraryButton constraintsRightInContainer:43]];
//        [self addConstraints:[_libraryButton constraintsLeft:30 FromView:_shootButton]];
    }
    return self;
}


@end
