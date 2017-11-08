//
//  UILabel+CountHeightAndWidth.m
//  HuPlus
//
//  Created by XT Xiong on 2016/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "UILabel+CountHeightAndWidth.h"

@implementation UILabel (CountHeightAndWidth)

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

+ (CGSize)contentSizeWithMaxLineNum:(NSUInteger)maxLineNum text:(NSString *)text
{
    CGSize contentSize;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.text = text;
    
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = label.lineBreakMode;
        paragraphStyle.alignment = label.textAlignment;
        NSDictionary * attributes = @{NSFontAttributeName : label.font,
                                      NSParagraphStyleAttributeName : paragraphStyle};
        CGSize tSize = CGSizeMake(label.width, MAXFLOAT);
        contentSize = [label.text boundingRectWithSize:tSize
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:attributes
                                              context:nil].size;
    } else {
        
        UIFont *thefont = label.font;
        CGSize size = CGSizeMake(label.width, label.font.pointSize*(maxLineNum+1));
        contentSize = [label.text  sizeWithFont:thefont constrainedToSize:size lineBreakMode:label.lineBreakMode];
    }
    return contentSize;
}

@end
