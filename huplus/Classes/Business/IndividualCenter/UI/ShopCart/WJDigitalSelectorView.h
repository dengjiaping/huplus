//
//  WJDigitalSelectorView.h
//  HuPlus
//
//  Created by reborn on 17/1/8.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WJDigitalSelectorViewBlock)(BOOL isIncrease);

@interface WJDigitalSelectorView : UIView

@property(nonatomic,strong)WJDigitalSelectorViewBlock countChangeBlock;

-(void)refeshDigitalSelectorViewWithCount:(NSInteger)count;

+(CGFloat)width;
+(CGFloat)height;

@end
