//
//  WJScanView.m
//  HuPlus
//
//  Created by reborn on 17/1/9.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJScanView.h"
#define kCameraWidth        ALD(300)

@interface WJScanView ()
{
    UIView      *scanBgView;
    UIImageView *scanQrImage;
    UIView      *borderView;
}

@end

@implementation WJScanView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //扫一扫灰色背景
        scanBgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        scanBgView.backgroundColor = [UIColor blackColor];
        scanBgView.alpha = 0.4;
//        scanBgView.layer.cornerRadius = 8;
        scanBgView.layer.shadowOpacity = 0.2;
        scanBgView.layer.shadowOffset = CGSizeMake(0.1, 1);
        scanBgView.layer.shadowRadius = 2;
        
        //二维码边框
        scanQrImage = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(26), ALD(96),scanBgView.width-ALD(26)*2, scanBgView.width-ALD(26)*2)];
        scanQrImage.image = [UIImage imageNamed:@"cardpackage_qr_border"];
        
        borderView = [[UIView alloc] initWithFrame:CGRectMake(ALD(30), ALD(100),scanBgView.width-ALD(30)*2, scanBgView.width-ALD(30)*2)];
        borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
        borderView.layer.borderWidth = 1;
        borderView.backgroundColor = [UIColor clearColor];
        
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(50), 0, kCameraWidth, ALD(2))];
        _line.image = [UIImage imageNamed:@"cardpackage_qr_line"];
        [self addSubview:scanBgView];
        [scanBgView addSubview:scanQrImage];
        [scanBgView addSubview:borderView];
        [scanQrImage addSubview:_line];
    }
    return self;
}
@end
