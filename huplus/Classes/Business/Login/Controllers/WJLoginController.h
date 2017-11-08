//
//  WJLoginController.h
//  HuPlus
//
//  Created by XT Xiong on 2016/12/20.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"


typedef enum
{
    LoginFromTabShopCart,        //tab购物车
    LoginFromTabCustom,          //tab定制
    LoginFromWebToUserId,        //给H5 userid
} LoginFrom;

@interface WJLoginController : WJViewController

@property(nonatomic , assign)LoginFrom      loginFrom;

@end
