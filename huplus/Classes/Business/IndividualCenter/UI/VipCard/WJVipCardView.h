//
//  WJVipCardView.h
//  HuPlus
//
//  Created by reborn on 16/12/22.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJVipCardViewDelegate <NSObject>

-(void)vipCardViewClickChargeRecord;
-(void)vipCardViewClickConsumeRecord;
-(void)vipCardViewClickCharge;

@end

@interface WJVipCardView : UIView
@property(nonatomic,weak)id<WJVipCardViewDelegate>delegate;

@end
