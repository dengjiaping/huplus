//
//  WJCustomBannerView.h
//  HuPlus
//
//  Created by reborn on 16/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageClickBlock)(NSInteger imageIndex);

typedef enum : NSUInteger {
    NSPageControlAlignmentCenter,//中间位置
    NSPageControlAlignmentRight,//右边位置
} NSPageControlAlignment;

@interface WJCustomBannerView : UIView

@property(nonatomic,retain)UIColor *curPageControlColor;
@property(nonatomic,retain)UIColor *otherPageControlColor;

+(instancetype)CreateBannerViewWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray timerWithTimeInterval:(NSTimeInterval)timeInterval imageClickBlock:(ImageClickBlock)imageClickBlock;

-(void)pasueTimer;

-(void)startTimer;

/**
 *  小圆点控制器的位置
 */
@property(nonatomic)NSPageControlAlignment pageControlAlignment;

@end
