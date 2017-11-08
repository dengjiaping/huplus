//
//  UIImageView+GCDImage.h
//  HuPlus
//
//  Created by reborn on 17/4/25.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GCDImage)

- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholder;

@end
