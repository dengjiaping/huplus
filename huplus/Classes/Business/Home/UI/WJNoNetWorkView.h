//
//  WJNoNetWorkView.h
//  HuPlus
//
//  Created by reborn on 17/4/20.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJNoNetWorkViewDelegate <NSObject>

-(void)clickRefreshButton;

@end

@interface WJNoNetWorkView : UIView
@property(nonatomic,weak)id<WJNoNetWorkViewDelegate> delegate;
@end
