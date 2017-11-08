//
//  WJChangePayPasswordController.h
//  HuPlus
//
//  Created by reborn on 17/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"

typedef NS_ENUM(NSInteger, ChangePayPsdType) {
    
    ChangePayPsdTypeNew,
    ChangePayPsdTypeConfirm,
    ChangePayPsdTypeVerify
};

@interface WJChangePayPasswordController : WJViewController
{
    NSMutableArray *psdArray;
    ChangePayPsdType enterPsdType;
    UITextField *tf;
}
@property (nonatomic, strong) NSString *oldPassword;
@property (nonatomic, strong) NSString *verifyCode;
@property (nonatomic, assign) ComeFrom from;

@property (nonatomic, assign) BOOL canInputPassword;

- (instancetype)initWithPsdType:(ChangePayPsdType)psdType;

- (void)cleanPsdView;


@end
