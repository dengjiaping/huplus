//
//  APIPictureUploadManager.h
//  HuPlus
//
//  Created by XT Xiong on 2017/3/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIPictureUploadManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString      * headPortrait;
@property (nonatomic, assign) NSString      * userId;

@end
