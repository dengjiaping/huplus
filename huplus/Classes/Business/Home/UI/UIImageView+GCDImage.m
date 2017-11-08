//
//  UIImageView+GCDImage.m
//  HuPlus
//
//  Created by reborn on 17/4/25.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "UIImageView+GCDImage.h"

@implementation UIImageView (GCDImage)

- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    NSString *name = [NSString stringWithFormat:@"%lu", (unsigned long)[urlString hash]];
    path = [NSString stringWithFormat:@"%@/%@", path, name];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage imageWithData:data];
        self.image = image;
        
    } else {
        
        self.image = placeholder;

        @autoreleasepool {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *url = [NSURL URLWithString:urlString];
                NSData *data = [NSData dataWithContentsOfURL:url];
                [data writeToFile:path atomically:YES];
                UIImage *image = [UIImage imageWithData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.image = image;
                });
            });
        }
    }
}
@end
