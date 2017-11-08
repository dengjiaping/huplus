//
//  WJNavigationController.h
//  HuPlus
//
//  Created by XT Xiong on 2016/12/15.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJNavigationController : UINavigationController

@property (nonatomic, strong) NSMutableArray *viewControllerStach;

//底部分割线
@property (nonatomic, strong) UIView * bottomLine;


- (void)replaceCurrentControllerWithController:(UIViewController *)vc;


/**
 *  <#Description#>
 *
 *  @param viewController 要推出的controller
 *  @param animated       动画效果
 *  @param jumped         当前controller是否跳过不再返回
 */
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
               whetherJump:(BOOL)jumped;

@end
