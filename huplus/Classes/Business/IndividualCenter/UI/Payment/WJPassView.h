//
//  WJPassView.h
//  HuPlus
//
//  Created by reborn on 17/1/11.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPaymentPsdAlertViewTag 100005

typedef enum
{
    PassViewTypeInputPassword = 0,
    PassViewTypeSubmit,
    PassViewTypeSubmitTip
}PassViewType;

@class WJPassView;
@protocol WJPassViewDelegate <NSObject>

- (void)successWithVerifyPsdAlert:(WJPassView *)alertView;

- (void)failedWithVerifyPsdAlert:(WJPassView *)alertView errerMessage:(NSString * )errerMessage isLocked:(BOOL)isLocked;

- (void)payWithAlert:(WJPassView *)alertView;

- (void)RechargeWithAlert:(WJPassView *)alertView;

- (void)forgetPasswordActionWith:(WJPassView *)alertView;

@end

@interface WJPassView : UIView
@property (nonatomic, weak) id<WJPassViewDelegate> delegate;
@property(nonatomic,assign) NSInteger alertTag;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title productName:(NSString *)productName
                amountNeedNum:(NSString *)amountNeedNum balanceHasNum:(NSString *)balanceHasNum passViewType:(PassViewType)passViewType;

- (void)showIn;

- (void)dismiss;
@end
