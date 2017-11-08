//
//  WJCameraController.h
//  HuPlus
//
//  Created by XT Xiong on 2017/2/24.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJViewController.h"

typedef void (^CameraControllerBlock)(NSDictionary *dicDic);


@interface WJCameraController : WJViewController

@property(nonatomic,copy)CameraControllerBlock            cameraControllerBlock;

@end
