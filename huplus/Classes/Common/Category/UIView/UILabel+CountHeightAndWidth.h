//
//  UILabel+CountHeightAndWidth.h
//  HuPlus
//
//  Created by XT Xiong on 2016/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CountHeightAndWidth)

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

+ (CGSize)contentSizeWithMaxLineNum:(NSUInteger)maxLineNum text:(NSString *)text;

@end
