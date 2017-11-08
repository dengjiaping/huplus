//
//  WJCreditsHeaderView.h
//  HuPlus
//
//  Created by reborn on 16/12/22.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJCreditsHeaderViewDelegate <NSObject>

-(void)creditsExchangeButtonClick;

@end

@interface WJCreditsHeaderView : UIView
@property(nonatomic, weak)id<WJCreditsHeaderViewDelegate>delegate;
- (void)refreshCreditsHeaderView:(NSString *)credits;

@end
