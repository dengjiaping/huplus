//
//  WJSelectDataPickerView.h
//  HuPlus
//
//  Created by reborn on 17/1/4.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJSelectDataPickerView;
@protocol WJSelectDataPickerViewDelegate <NSObject>

-(void)selectDataPickerView:(WJSelectDataPickerView *)dataPickerViewView clickCancelButton:(UIButton *)cancelButton;
-(void)selectDataPickerView:(WJSelectDataPickerView *)dataPickerViewView clickConfirmButtonWithSelectBirthDay:(NSString *)string;

@end

@interface WJSelectDataPickerView : UIView
@property(nonatomic,weak)id<WJSelectDataPickerViewDelegate>delegate;

@end
