//
//  WJChooseViewCell.h
//  HuPlus
//
//  Created by reborn on 16/12/23.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJChooseViewCell : UIView

@property(nonatomic,assign) BOOL selected;
- (instancetype) initWithPoint:(CGPoint)point value:(NSString *)value des:(NSString *)describe;
@end
