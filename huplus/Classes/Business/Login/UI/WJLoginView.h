//
//  WJLoginView.h
//  HuPlus
//
//  Created by XT Xiong on 2016/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GetVerifyCodeBlock)();

@interface WJLoginView : UIView

@property(nonatomic,strong)UITextField          * phoneTextField;
@property(nonatomic,strong)UITextField          * verifyTextField;
@property(nonatomic,strong)UIButton             * getVerifyCodeBtn;
@property(nonatomic,strong)UIButton             * loginBtn;
@property(nonatomic,strong)UIButton             * changeBtn;
@property(nonatomic,strong)NSTimer              * verifyTimer;

@property(nonatomic,copy)GetVerifyCodeBlock       getVerifyCodeBlock;

- (void)startTimer;

@end
