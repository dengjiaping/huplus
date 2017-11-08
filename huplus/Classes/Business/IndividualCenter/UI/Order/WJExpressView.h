//
//  WJExpressView.h
//  HuPlus
//
//  Created by reborn on 17/3/24.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJExpressViewDelegate <NSObject>

-(void)startEditExpressView:(UITextField *)textField;
-(void)endEditExpressView:(UITextField *)textField;

@end

@interface WJExpressView : UIView

@property(nonatomic,weak)id <WJExpressViewDelegate> delegate;
@property(nonatomic,strong)UITextField *expressTF;

-(void)configDataWithTitle:(NSString *)title placeholder:(NSString *)placeholder isShowArrowIV:(BOOL)isShowArrowIV;

@end
