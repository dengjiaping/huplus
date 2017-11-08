//
//  WJChangeNickNameViewController.h
//  HuPlus
//
//  Created by reborn on 17/1/10.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"

typedef void(^ChangeNickNameBlock)(NSString *name);

@interface WJChangeNickNameViewController : WJViewController
@property(nonatomic,strong)ChangeNickNameBlock nickNameBlock;
@property(nonatomic,strong)NSString         *nickName;
@end
