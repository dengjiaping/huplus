//
//  WJTabBarController.h
//  HuPlus
//
//  Created by XT Xiong on 2016/12/15.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJTabBarController : UITabBarController

@property(nonatomic,strong)UIImageView   * backGroundIV;

- (void)changeTabIndex:(NSInteger)index;
-(void)receiveNotification;
@end
