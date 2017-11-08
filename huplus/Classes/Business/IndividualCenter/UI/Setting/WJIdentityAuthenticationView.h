//
//  WJIdentityAuthenticationView.h
//  HuPlus
//
//  Created by reborn on 17/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GetVerifyCodeBlock)();

@interface WJIdentityAuthenticationView : UIView
@property(nonatomic,strong)UITextField          * phoneTextField;
@property(nonatomic,strong)UITextField          * verifyTextField;
@property(nonatomic,strong)UIButton             * getVerifyCodeBtn;
@property(nonatomic,strong)UIButton             * nextBtn;
@property(nonatomic,strong)NSTimer              * verifyTimer;

@property(nonatomic,copy)GetVerifyCodeBlock       getVerifyCodeBlock;
@end
