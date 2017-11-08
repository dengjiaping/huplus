//
//  WJBaseScrollView.m
//  HuPlus
//
//  Created by reborn on 16/12/23.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJBaseScrollView.h"

@implementation WJBaseScrollView

//-(BOOL)touchesShouldCancelInContentView:(UIView *)view
//{
//    return YES;
//}

//- (BOOL)touchesShouldCancelInContentView:(UIView *)view
//{
//    if ([view isKindOfClass:NSClassFromString(@"WJBaseScrollView")]) {
//        
//        return YES;
//        
//    } else {
//        return [super touchesShouldCancelInContentView:view];
//    }
//}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if (gestureRecognizer.state != 0) {
//        return YES;
//    } else {
//        return NO;
//    }
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
//    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
//        return YES;
//    }
////    NSLog(@"_____%@______other:%@",gestureRecognizer,otherGestureRecognizer);
//    return NO;
    
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
        return NO;
    }
    return YES;
}
@end
